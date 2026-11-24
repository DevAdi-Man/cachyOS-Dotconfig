local M = {}

function M.complete(findstart, base)
  local uri = vim.b.db or vim.env.MONGODB_URI or ""
  if
    type(uri) ~= "string"
    or not (uri:match("^mongodb://") or uri:match("^mongodb%+srv://"))
    or (vim.fn.executable("mongosh") == 0 and vim.fn.executable("mongo") == 0)
  then
    uri = ""
  end
  return vim.fn["dbcp#adapter#mongodb#complete"](findstart, base, uri)
end

return M
