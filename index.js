const express = require("express");
const StyLua = require("@johnnymorganz/stylua");
const app = express();

// StyLua Roblox Plugin
// Version 1.0.0

const EnumList = {
  ["call_parentheses"]: StyLua.CallParenType,
  ["collapse_simple_statement"]: StyLua.CollapseSimpleStatement,
  ["indent_type"]: StyLua.IndentType,
  ["line_endings"]: StyLua.LineEndings,
  ["quote_style"]: StyLua.QuoteStyle,
};

app.use(express.text());
app.post("/stylua", (req, res) => {
  const input = req.body;
  const Query = req.query.Config;

  var Configs = StyLua.Config.new();

  if (Query) {
    const Parsed = JSON.parse(Query);
    for (const [key, value] of Object.entries(Parsed)) {
      if (EnumList[key]) {
        Configs[key] = EnumList[key][value];
      } else if (key == "sort_requires") {
        Configs[key] = StyLua.SortRequiresConfig.new().set_enabled(value);
      } else {
        Configs[key] = value;
      }
    }
  }

  const output = StyLua.formatCode(
    input,
    Configs,
    StyLua.Range.from_values(),
    StyLua.OutputVerification.None
  );

  res.setHeader("Content-Type", "text/plain");
  res.send(output);
});

app.listen(18259, () => {
  console.log("Server started on port 18259");
});
