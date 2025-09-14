from unittest import TestCase

import tree_sitter, tree_sitter_ucode


class TestLanguage(TestCase):
    def test_can_load_grammar(self):
        try:
            tree_sitter.Language(tree_sitter_ucode.language())
        except Exception:
            self.fail("Error loading ucode grammar")
