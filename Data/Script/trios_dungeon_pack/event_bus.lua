EventBus = {
  listeners = {}
}

function EventBus:Subscribe(event, fn)
  self.listeners[event] = self.listeners[event] or {}
  table.insert(self.listeners[event], fn)
  return fn
end

function EventBus:Unsubscribe(event, fn)
  local list = self.listeners[event]
  if not list then return end

  for i = #list, 1, -1 do
    if list[i] == fn then
      table.remove(list, i)
      return
    end
  end
end

function EventBus:Emit(event, data)
  local list = self.listeners[event]
  if not list then return end

  for _, fn in ipairs(list) do
    fn(data)
  end
end
