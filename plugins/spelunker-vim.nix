# Spell checker for words in CamelCase and snake_case
{ spelunker-vim }: {
  plugin = spelunker-vim;
  config = ''
    let g:spelunker_check_type = 1
  '';
}
