#!/usr/bin/env python3
"""Check repository Markdown links and reviewed translation fingerprints.

Standard-library maintainer tool. Checks inline and reference-style local links,
ATX/Setext headings and explicit HTML anchors outside fenced code. It does not
fetch external URLs or interpret bare paths in prose/code as links.
"""
import hashlib
import json
from pathlib import Path
import re
import sys
from urllib.parse import unquote, urlsplit

ROOT = Path(__file__).resolve().parents[1]


def prose(text):
    result = []
    fence = None
    for line in text.splitlines():
        marker = re.match(r'^\s{0,3}(`{3,}|~{3,})', line)
        if marker:
            run = marker[1]
            if fence is None:
                fence = run
            elif run[0] == fence[0] and len(run) >= len(fence):
                fence = None
            result.append('')
        else:
            result.append('' if fence else line)
    return '\n'.join(result)


def anchors(text):
    text = prose(text)
    result = set(re.findall(r'\b(?:id|name)=["\']([^"\']+)["\']', text))
    seen = {}
    lines = text.splitlines()
    for i, line in enumerate(lines):
        heading = re.match(r'^ {0,3}#{1,6}\s+(.+?)(?:\s+#+)?$', line)
        title = heading[1] if heading else None
        if not heading and i + 1 < len(lines) and re.fullmatch(r' {0,3}(?:=+|-+)\s*', lines[i+1]) and line.strip():
            title = line.strip()
        if title is None:
            continue
        title = re.sub(r'<[^>]*>', '', title).lower()
        title = re.sub(r'\[([^]]+)\]\([^)]*\)', r'\1', title)
        slug = ''.join(c for c in title if c.isalnum() or c in '-_ ' or ord(c) > 127).replace(' ', '-')
        number = seen.get(slug, 0)
        seen[slug] = number + 1
        result.add(slug + (f'-{number}' if number else ''))
    return result


def link_errors(path, root):
    text = prose(path.read_text(encoding='utf-8'))
    links = list(re.finditer(r'!?\[[^\]\n]*\]\((<[^>]+>|[^\s)]+)(?:\s+["\'][^\n]*?["\'])?\)', text))
    links += list(re.finditer(r'^ {0,3}\[[^\]]+\]:\s*(<[^>]+>|\S+)', text, re.M))
    errors = []
    for match in links:
        url = match[1].strip('<>')
        parts = urlsplit(url)
        if parts.scheme or parts.netloc:
            continue
        target = (root / unquote(parts.path).lstrip('/')) if parts.path.startswith('/') else (path.parent / unquote(parts.path))
        target = target.resolve() if parts.path else path
        reason = None
        if not target.exists():
            reason = 'missing local destination'
        elif parts.fragment and target.suffix.lower() == '.md':
            if unquote(parts.fragment) not in anchors(target.read_text(encoding='utf-8')):
                reason = 'missing heading/anchor'
        if reason:
            errors.append(f'{path.relative_to(root)}:{text[:match.start()].count(chr(10))+1}: {reason}: {url}')
    return errors


def translation_pair_inventory(path):
    pairs = []
    errors = []
    for number, line in enumerate(path.read_text(encoding='utf-8').splitlines(), 1):
        if not line.strip():
            continue
        fields = line.split('|')
        if len(fields) != 2 or not all(field.strip() for field in fields):
            errors.append(f'{path}: line {number}: expected source|translation')
            continue
        pairs.append((fields[0].strip(), fields[1].strip()))
    if len(pairs) != len(set(pairs)):
        errors.append(f'{path}: duplicate source/translation pair')
    return pairs, errors


def translation_review_errors(root):
    manifest = root / 'scripts/translation-pairs.tsv'
    review_path = root / 'locales/translation-review.json'
    pairs, errors = translation_pair_inventory(manifest)
    expected = set(pairs)
    for source, translation in pairs:
        for relative in (source, translation):
            if not (root / relative).is_file():
                errors.append(f'{relative}: active translation pair file is missing')

    review = json.loads(review_path.read_text(encoding='utf-8'))
    recorded = set()
    for entry in review.get('reviewed_pairs', []):
        pair = (entry.get('source'), entry.get('translation'))
        if pair in recorded:
            errors.append(f'{pair[0]}: duplicate semantic review record')
        recorded.add(pair)
        if pair not in expected:
            errors.append(f'{pair[0]}: review record is not in the active translation inventory')
        if not entry.get('scope', '').strip():
            errors.append(f'{pair[0]}: semantic review scope is missing')
        for key in ('source', 'translation'):
            relative = entry.get(key, '')
            path = root / relative
            if not path.is_file():
                errors.append(f'{relative}: reviewed translation pair file is missing')
                continue
            digest = hashlib.sha256(path.read_bytes()).hexdigest()
            if digest != entry.get(key + '_sha256'):
                errors.append(f'{relative}: changed since semantic review; review the pair and update its fingerprint')
    for source, translation in sorted(expected - recorded):
        errors.append(f'{source}: active translation pair has no semantic review record ({translation})')
    return errors, len(expected), len(recorded)


def main():
    errors = []
    files = [p for p in ROOT.rglob('*.md') if not any(part in ('.git', 'dist', '__pycache__') for part in p.relative_to(ROOT).parts)]
    for file in files:
        errors.extend(link_errors(file, ROOT))
    # These are explicit review records, not automatic semantic certification.
    review_errors, active_pairs, reviewed_pairs = translation_review_errors(ROOT)
    errors.extend(review_errors)
    for file in (ROOT / 'agents').glob('*/SPECS.md'):
        if re.search(r'\b(Você|Voce|Não|Nao|Objetivo Principal|Responsabilidades)\b', file.read_text(encoding='utf-8')):
            errors.append(f'{file.relative_to(ROOT)}: Portuguese prose in canonical EN-US specification')
    if errors:
        print('\n'.join(errors), file=sys.stderr)
        return 1
    print(f'Document checks passed: {len(files)} Markdown files; {reviewed_pairs}/{active_pairs} active translation pairs have current semantic review records.')
    return 0


if __name__ == '__main__':
    sys.exit(main())
