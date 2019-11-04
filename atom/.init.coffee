# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.
#
# An example hack to log to the console when each text editor is saved.
#
# atom.workspace.observeTextEditors (editor) ->
#   editor.onDidSave ->
#     console.log "Saved! #{editor.getPath()}"




{Point} = require 'atom'



#------------------------------ 
# Move between keyboards:
#------------------------------
goToTerm = (editor, string, flag) ->
  # body...
  cursor = editor.getCursorBufferPosition()
  x      = cursor.row
  y      = cursor.column
  buffer = editor.lineTextForBufferRow(x)
  mode   = flag & 1
  
  if mode == 0
    buffer = buffer.substr(y)
  else
    buffer = buffer.substr(0, y)
    
  # search for the term:
  found = false
  iy    = 0
  
  r = []
  if mode == 0
    r = [0..buffer.length]
  else
    r = [buffer.length-1..0]
  
  for index in r by 1
    char = buffer[index]
    # console.log char
    iy = iy + 1
    if char == string
      found = true
      break
  
  if found 
    py = 0
    if mode == 0
      py = y + iy - 1
    else
      py = y - iy + 1
    
    ct = [x, py]
    
    if flag == 1 || flag == 0
      editor.setCursorBufferPosition(ct)
    if flag == 2 || flag == 3
      editor.setSelectedBufferRange([cursor, ct]) 

atom.commands.add 'atom-text-editor', 'custom:jump-to-next-apostrophe', ->
  return unless editor = atom.workspace.getActiveTextEditor()
  goToTerm(editor, '\'', 0)

atom.commands.add 'atom-text-editor', 'custom:jump-to-prev-apostrophe', ->
  return unless editor = atom.workspace.getActiveTextEditor()
  goToTerm(editor, '\'', 1)

atom.commands.add 'atom-text-editor', 'custom:select-to-next-apostrophe', ->
  return unless editor = atom.workspace.getActiveTextEditor()
  goToTerm(editor, '\'', 2)

atom.commands.add 'atom-text-editor', 'custom:select-to-prev-apostrophe', ->
  return unless editor = atom.workspace.getActiveTextEditor()
  goToTerm(editor, '\'', 3)

atom.commands.add 'atom-text-editor', 'custom:jump-to-next-quotation', ->
  return unless editor = atom.workspace.getActiveTextEditor()
  goToTerm(editor, '\"', 0)

atom.commands.add 'atom-text-editor', 'custom:jump-to-prev-quotation', ->
  return unless editor = atom.workspace.getActiveTextEditor()
  goToTerm(editor, '\"', 1)

atom.commands.add 'atom-text-editor', 'custom:select-to-next-quotation', ->
  return unless editor = atom.workspace.getActiveTextEditor()
  goToTerm(editor, '\"', 2)

atom.commands.add 'atom-text-editor', 'custom:select-to-prev-quotation', ->
  return unless editor = atom.workspace.getActiveTextEditor()
  goToTerm(editor, '\"', 3)

#------------------------------ 
# Custom status-bar:
#------------------------------
line = 0 # for some reason I cannot use this inside class because of goToLine func
class StatusBarItem

  constructor: (default_text) ->
    status_bar_left = document.getElementsByClassName("status-bar-left")[0]
    status_bar_selection = status_bar_left.children[3]
    @status_bar_function = document.createElement("div")
    @status_bar_function.classList.value = "inline-block"
    @status_bar_function_text = document.createTextNode(default_text)
    @status_bar_function.appendChild(@status_bar_function_text)
    status_bar_left.insertBefore(@status_bar_function , status_bar_selection)
    
    
  setText: (txt, l) ->
    @status_bar_function_text.nodeValue = txt
    @status_bar_function_text.removeEventListener("click", this.goToLine)
    @status_bar_function.addEventListener("click", this.goToLine)
    line = l
    
  goToLine: () ->
    atom.workspace.getActiveTextEditor()?.setCursorBufferPosition([line, 0])
    
status_bar_item = new StatusBarItem("")

# RUBY look for function name: 
atom.commands.add 'atom-text-editor', 'custom:look-for-func-ruby', ->
  return unless editor = atom.workspace.getActiveTextEditor()
  cursor = editor.getCursorBufferPosition()
  x      = cursor.row
  
  while (x > 0)
    buffer = editor.lineTextForBufferRow(x)
    buffer_trim = buffer.trim()
    if buffer_trim.startsWith("def")
      status_bar_item.setText(buffer_trim.substring(4), x)
      break
    x -= 1
