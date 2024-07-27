M_HELPERS = {
  map = function (tbl, f)
    local t = {}
    for k,v in ipairs(tbl) do
        t[k] = f(v)
    end
    return t
  end
  

}