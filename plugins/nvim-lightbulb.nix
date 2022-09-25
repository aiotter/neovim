# Show visual notification if code actions are available at the current line
{ nvim-lightbulb }: {
  plugin = nvim-lightbulb;
  config = ''
    lua <<EOF
    require('nvim-lightbulb').setup({
      visual_text = { enabled = true },
      status_text = { enabled = true },
    })
    EOF
  '';
}
