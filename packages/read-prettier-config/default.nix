{ writers, prettier }:

writers.writeJSBin "read-prettier-config"
  {
    libraries = [ prettier ];
  }
  ''
    const prettier = require("prettier");
    const file = process.argv[2];

    if (!file) {
      process.stderr.write("expected file path\n");
      process.exit(1);
    }

    (async () => {
      const config = await prettier.resolveConfig(file, { editorconfig: true });
      process.stdout.write(JSON.stringify(config || {}));
    })().catch((err) => {
      process.stderr.write(String((err && err.stack) || err));
      process.exit(1);
    });
  ''
