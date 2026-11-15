"""Behavior tests; Python is a maintainer/CI dependency, never a setup dependency."""
import os
from pathlib import Path
import shutil
import signal
import subprocess
import tempfile
import time
import unittest

ROOT = Path(__file__).resolve().parents[2]


class BootstrapSafety(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix='lf-setup-tests-')
        self.base = Path(self.temp.name)
        self.framework = self.base / 'framework'
        self.framework.mkdir()
        for name in ('PROJECT_TEMPLATE', 'locales', 'adapters', 'scripts'):
            shutil.copytree(ROOT / name, self.framework / name, ignore=shutil.ignore_patterns('__pycache__'))
        self.target = self.base / 'ação project'

    def tearDown(self):
        self.temp.cleanup()

    def run_backend(self, backend, target=None, language='pt-BR', adapter='generic', apply=True):
        target = target or self.target
        script = self.framework / 'scripts' / ('bootstrap.' + backend)
        if backend == 'sh':
            args = ['sh', str(script), '--target', str(target), '--language', language, '--adapter', adapter, '--apply' if apply else '--dry-run']
        else:
            args = ['pwsh', '-NoLogo', '-NoProfile', '-File', str(script), '-TargetPath', str(target), '-Language', language, '-Adapter', adapter, '-Apply' if apply else '-DryRun']
        return subprocess.run(args, cwd=self.base, text=True, capture_output=True, timeout=30)

    def backends(self):
        return (['sh'] if os.name != 'nt' else []) + (['ps1'] if shutil.which('pwsh') else [])

    def test_invalid_target_leaves_no_directory(self):
        for backend in self.backends():
            for target in (self.framework / 'forbidden', self.base / 'missing' / '..' / 'framework' / 'forbidden'):
                with self.subTest(backend=backend, target=target):
                    result = self.run_backend(backend, target)
                    self.assertNotEqual(result.returncode, 0, result.stdout)
                    self.assertFalse((self.framework / 'forbidden').exists())
                    self.assertFalse((self.base / 'missing').exists())

    def test_missing_adapter_is_detected_before_writing(self):
        (self.framework / 'adapters/opencode/opencode.jsonc').unlink()
        for backend in self.backends():
            result = self.run_backend(backend, adapter='opencode')
            self.assertNotEqual(result.returncode, 0)
            self.assertFalse(self.target.exists())

    def test_missing_adapter_placeholder_fails_before_writes(self):
        (self.framework / 'adapters/opencode/opencode.jsonc').write_text('{}')
        for backend in self.backends():
            result = self.run_backend(backend, adapter='opencode')
            self.assertNotEqual(result.returncode, 0)
            self.assertFalse(self.target.exists())

    @unittest.skipIf(os.name == 'nt', 'Quotes are not valid Windows filename characters')
    def test_quoted_framework_path_renders_valid_adapter_json(self):
        import json
        new_path = self.base / 'framework "quoted"'
        self.framework.rename(new_path)
        self.framework = new_path
        for backend in self.backends():
            target = self.base / backend
            result = self.run_backend(backend, target=target, adapter='opencode')
            self.assertEqual(result.returncode, 0, result.stderr)
            config_text = (target / 'opencode.jsonc').read_text(encoding='utf-8')
            json.loads(config_text)
            self.assertNotIn('__LF_ENGINEERING_SYSTEM_PATH__', config_text)
            self.assertIn('agents/Engineering-Manager/SPECS.md', config_text)
            self.assertIn('workflows/NEW_PROJECT.md', config_text)
            self.assertIn('workflows/STANDARD_DEVELOPMENT.md', config_text)
            self.assertNotIn('/.opencode/', config_text)

    def test_missing_locale_is_detected_before_writing(self):
        shutil.rmtree(self.framework / 'locales/pt-BR/PROJECT_TEMPLATE')
        for backend in self.backends():
            result = self.run_backend(backend)
            self.assertNotEqual(result.returncode, 0)
            self.assertFalse(self.target.exists())

    def test_existing_parent_file_fails_before_other_files_are_added(self):
        self.target.mkdir()
        (self.target / '.ai').write_text('owned by project')
        for backend in self.backends():
            result = self.run_backend(backend)
            self.assertNotEqual(result.returncode, 0)
            self.assertEqual(list(self.target.iterdir()), [self.target / '.ai'])

    def test_invalid_framework_placeholder_fails_before_writes(self):
        (self.framework / 'locales/pt-BR/PROJECT_TEMPLATE/LF_ENGINEERING.md').write_text('invalid template')
        for backend in self.backends():
            result = self.run_backend(backend)
            self.assertNotEqual(result.returncode, 0)
            self.assertFalse(self.target.exists())

    def test_language_adapters_preview_and_repeat_preserve_content(self):
        for backend in self.backends():
            for language in ('en-US', 'pt-BR'):
                for adapter in ('generic', 'codex', 'claude', 'gemini', 'opencode'):
                    with self.subTest(backend=backend, language=language, adapter=adapter):
                        target = self.base / (backend + language + adapter + ' ação')
                        result = self.run_backend(backend, target, language, adapter, apply=False)
                        self.assertEqual(result.returncode, 0, result.stderr)
                        self.assertFalse(target.exists())
                        additions = [x for x in result.stdout.splitlines() if x.startswith('ADD ')]
                        self.assertEqual(len(additions), len(set(additions)))
                        result = self.run_backend(backend, target, language, adapter)
                        self.assertEqual(result.returncode, 0, result.stderr)
                        record = (target / '.ai/framework-installation.md').read_text(encoding='utf-8')
                        self.assertIn('- Language: ' + language, record)
                        self.assertIn('Instalação' if language == 'pt-BR' else 'Installation', record)
                        before = {p.relative_to(target): p.read_bytes() for p in target.rglob('*') if p.is_file()}
                        result = self.run_backend(backend, target, language, adapter)
                        self.assertEqual(result.returncode, 0, result.stderr)
                        self.assertEqual(before, {p.relative_to(target): p.read_bytes() for p in target.rglob('*') if p.is_file()})


class Assistant(unittest.TestCase):
    def test_help_shows_creator_contact(self):
        commands = []
        if os.name != 'nt':
            commands.append(['sh', str(ROOT / 'setup.sh'), '--help'])
        if shutil.which('pwsh'):
            commands.append(['pwsh', '-NoLogo', '-NoProfile', '-File', str(ROOT / 'setup.ps1'), '-Help'])
        for command in commands:
            with self.subTest(command=command[0]):
                result = subprocess.run(command, text=True, capture_output=True, cwd=tempfile.gettempdir(), timeout=15)
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertIn('Leandro Fernandes', result.stdout)
                self.assertIn('leandorfernandes1600@gmail.com', result.stdout)

    def test_redirected_input_is_rejected_without_prompt(self):
        commands = []
        if os.name != 'nt':
            commands.append(['sh', str(ROOT / 'setup.sh')])
        if shutil.which('pwsh'):
            commands.append(['pwsh', '-NoLogo', '-NoProfile', '-File', str(ROOT / 'setup.ps1')])
        for cmd in commands:
            result = subprocess.run(cmd, input='', text=True, capture_output=True, cwd=tempfile.gettempdir(), timeout=15)
            self.assertNotEqual(result.returncode, 0)
            self.assertIn('interativo', result.stdout + result.stderr)

    @unittest.skipIf(os.name == 'nt', 'POSIX PTY test; native Windows backend tests run separately')
    def test_terminal_sessions(self):
        import pty
        import select
        commands = [(['sh', str(ROOT / 'setup.sh'), '--no-animation', '--no-color'], False),
                    (['sh', str(ROOT / 'setup.sh'), '--no-color'], True)]
        if shutil.which('pwsh'):
            commands.append((['pwsh', '-NoLogo', '-NoProfile', '-File', str(ROOT / 'setup.ps1'), '-NoAnimation', '-NoColor'], False))
            commands.append((['pwsh', '-NoLogo', '-NoProfile', '-File', str(ROOT / 'setup.ps1'), '-NoColor'], True))
        for command, animated in commands:
            for language, confirm in [('1', 'n'), ('2', 'y'), ('1', 's')]:
                with self.subTest(command=command[0], language=language, confirm=confirm), tempfile.TemporaryDirectory() as directory:
                    target = Path(directory) / 'ação project'
                    if confirm == 's':
                        (target / '.ai').mkdir(parents=True)
                        (target / '.ai/framework-installation.md').write_text('- Language: en-US\n- Adapter: codex\n')
                    master, slave = pty.openpty()
                    env = dict(os.environ, TERM='xterm-256color' if animated else 'dumb', COLUMNS='80', NO_COLOR='1')
                    env.pop('CI', None)
                    process = subprocess.Popen(command, stdin=slave, stdout=slave, stderr=slave, cwd=directory, env=env, start_new_session=True)
                    os.close(slave)
                    output = b''
                    steps = [('Language / Idioma:', language), ('diretório atual' if language == '1' else 'current directory', str(target)), ('OpenCode', ''), ('[s/N]' if language == '1' else '[y/N]', confirm)]
                    deadline = time.monotonic() + 30
                    try:
                        while time.monotonic() < deadline:
                            ready, _, _ = select.select([master], [], [], .1)
                            if ready:
                                try:
                                    chunk = os.read(master, 65536)
                                except OSError:
                                    break
                                if not chunk:
                                    break
                                output += chunk
                                if steps and steps[0][0].encode() in output:
                                    _, answer = steps.pop(0)
                                    os.write(master, (answer + '\n').encode())
                            if process.poll() is not None:
                                break
                        self.assertFalse(steps, output.decode(errors='replace'))
                        self.assertEqual(process.wait(timeout=3), 0, output.decode(errors='replace'))
                        self.assertIn(b'Leandro Fernandes', output)
                        self.assertIn(b'leandorfernandes1600@gmail.com', output)
                        if animated:
                            self.assertIn(b'\x1b[K', output)
                            self.assertNotIn(b'\x1b[36m', output)
                        else:
                            self.assertNotIn(b'\x1b[', output)
                        self.assertEqual(target.exists(), confirm != 'n')
                        if language == '1':
                            self.assertIn('ADICIONAR'.encode(), output)
                        if confirm == 's':
                            self.assertIn('registro de instalação difere'.encode(), output)
                            self.assertIn('- Language: en-US', (target / '.ai/framework-installation.md').read_text())
                    finally:
                        if process.poll() is None:
                            os.killpg(process.pid, signal.SIGTERM)
                            process.wait()
                        os.close(master)

    @unittest.skipIf(os.name == 'nt', 'POSIX PTY')
    def test_narrow_terminal_uses_static_brand(self):
        import pty
        import select
        with tempfile.TemporaryDirectory() as directory:
            master, slave = pty.openpty()
            env = dict(os.environ, TERM='xterm-256color', COLUMNS='36', NO_COLOR='1')
            env.pop('CI', None)
            process = subprocess.Popen(['sh', str(ROOT / 'setup.sh')], stdin=slave, stdout=slave, stderr=slave, cwd=directory, env=env, start_new_session=True)
            os.close(slave)
            output = b''
            try:
                deadline = time.monotonic() + 10
                while b'Language / Idioma:' not in output and time.monotonic() < deadline:
                    if select.select([master], [], [], .1)[0]:
                        output += os.read(master, 4096)
                self.assertIn(b'LF Engineering Framework', output)
                self.assertIn(b'leandorfernandes1600@gmail.com', output)
                self.assertNotIn(b'\x1b[', output)
                os.write(master, b'\x04')
                self.assertIn(process.wait(timeout=5), (0, 130))
            finally:
                if process.poll() is None:
                    os.killpg(process.pid, signal.SIGTERM)
                    process.wait()
                os.close(master)

    @unittest.skipIf(os.name == 'nt', 'POSIX signals/PTY')
    def test_eof_and_interrupt_before_confirmation(self):
        import pty
        import select
        for interrupted in (False, True):
            with tempfile.TemporaryDirectory() as directory:
                master, slave = pty.openpty()
                env = dict(os.environ, TERM='xterm-256color')
                env.pop('CI', None)
                process = subprocess.Popen(['sh', str(ROOT / 'setup.sh')], stdin=slave, stdout=slave, stderr=slave, cwd=directory, env=env, start_new_session=True)
                os.close(slave)
                output = b''
                try:
                    deadline = time.monotonic() + 10
                    while b'Language / Idioma:' not in output and time.monotonic() < deadline:
                        if select.select([master], [], [], .1)[0]:
                            output += os.read(master, 4096)
                    self.assertIn(b'Language / Idioma:', output)
                    if interrupted:
                        os.killpg(process.pid, signal.SIGINT)
                    else:
                        os.write(master, b'\x04')
                    self.assertIn(process.wait(timeout=5), (0, 130))
                    self.assertEqual(list(Path(directory).iterdir()), [])
                finally:
                    if process.poll() is None:
                        os.killpg(process.pid, signal.SIGTERM)
                        process.wait()
                    os.close(master)


if __name__ == '__main__':
    unittest.main()
