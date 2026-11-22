import importlib.util
import json
from pathlib import Path
import tempfile
import unittest

spec = importlib.util.spec_from_file_location('check_docs', Path(__file__).parents[1] / 'check-docs.py')
docs = importlib.util.module_from_spec(spec)
spec.loader.exec_module(docs)


class DocumentationLinks(unittest.TestCase):
    def test_local_links_and_anchors(self):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            target = root / 'ação.md'
            target.write_text('# Instalação\n\n# Instalação\n\n<a id="custom"></a>\n', encoding='utf-8')
            source = root / 'README.md'
            source.write_text('[valid](a%C3%A7%C3%A3o.md#instalação-1)\n[custom](ação.md#custom)\n[missing](ação.md#bad)\n[ref]: absent.md\n```md\n[example](not-a-file.md)\n```\n', encoding='utf-8')
            errors = docs.link_errors(source, root)
            self.assertEqual(len(errors), 2, errors)
            self.assertIn('missing heading/anchor', errors[0])
            self.assertIn('missing local destination', errors[1])

    def test_code_headings_do_not_create_anchors(self):
        self.assertEqual(docs.anchors('# Real\n~~~\n# Fake\n~~~\n'), {'real'})

    def test_translation_review_requires_inventory_coverage_and_current_hashes(self):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            (root / 'scripts').mkdir()
            source = root / 'source.md'
            translation = root / 'translation.md'
            source.write_text('Canonical source\n', encoding='utf-8')
            translation.write_text('Fonte canônica\n', encoding='utf-8')
            (root / 'scripts/translation-pairs.tsv').write_text(
                'source.md|translation.md\n', encoding='utf-8')
            entry = {
                'source': 'source.md',
                'translation': 'translation.md',
                'source_sha256': docs.semantic_fingerprint(source),
                'translation_sha256': docs.semantic_fingerprint(translation),
                'scope': 'Meaning, identifiers and omissions reviewed',
            }
            (root / 'locales').mkdir()
            review_path = root / 'locales/translation-review.json'
            review_path.write_text(json.dumps({'reviewed_pairs': [entry]}), encoding='utf-8')
            errors, active, reviewed = docs.translation_review_errors(root)
            self.assertEqual(errors, [])
            self.assertEqual((active, reviewed), (1, 1))

            source.write_bytes(source.read_bytes().replace(b'\n', b'\r\n'))
            translation.write_bytes(translation.read_bytes().replace(b'\n', b'\r\n'))
            errors, _, _ = docs.translation_review_errors(root)
            self.assertEqual(errors, [])

            source.write_text('Changed source\n', encoding='utf-8')
            errors, _, _ = docs.translation_review_errors(root)
            self.assertTrue(any('changed since semantic review' in error for error in errors))

            review_path.write_text(json.dumps({'reviewed_pairs': []}), encoding='utf-8')
            errors, _, _ = docs.translation_review_errors(root)
            self.assertTrue(any('has no semantic review record' in error for error in errors))

    def test_translation_pair_inventory_rejects_duplicates_and_malformed_rows(self):
        with tempfile.TemporaryDirectory() as folder:
            inventory = Path(folder) / 'translation-pairs.tsv'
            inventory.write_text('a.md|pt/a.md\na.md|pt/a.md\ninvalid\n', encoding='utf-8')
            pairs, errors = docs.translation_pair_inventory(inventory)
            self.assertEqual(pairs, [('a.md', 'pt/a.md'), ('a.md', 'pt/a.md')])
            self.assertEqual(len(errors), 2)
