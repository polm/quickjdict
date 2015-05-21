fs = require \fs

# read dict
# register input
# show results

file = fs.read-file-sync \edict2.utf8, \utf-8

dict = file.split "\n" # each line is one entry

results-div = document.query-selector \#results
query-box = document.query-selector \input

get-matches = (query) ->
  regex = new RegExp(MigemoJS.getRegExp(query.trim!))
  matches = []
  for entry in dict
    hits = regex.exec entry
    if hits
      highlighted = entry.split(hits[0]).join("<span class=\"hit\">#{hits[0]}</span>")
      matches.push highlighted
      if matches.length > 1000 then break
  return matches

add-result = ->
  div = document.create-element \div
  div.class-list.add \result
  div.innerHTML = it
  results-div.append-child div
  return div

update-results = ->
  results-div.innerHTML = ''
  matches = get-matches(query-box.value)
  matches.map add-result

# debounce based on underscore

debounce = (func, wait) ->
  result = null
  timeout = null
  timestamp = null

  later = ->
    last-called = new Date! - timestamp

    if last-called < wait and last-called >= 0
      timeout = set-timeout later, wait - last-called
    else
      timeout = null
      result = func! # we have no context or args

  return ->
    timestamp = new Date!
    if not timeout
      timeout = set-timeout later, wait
    return result

debounced-update = debounce update-results, 300

query-box.onkeyup = debounced-update
