JsOsaDAS1.001.00bplist00�Vscript_// Get current context.
ctx = Application.currentApplication()
ctx.includeStandardAdditions = true

function tbl_map(tbl, f) {
  var res = []
  var rows = tbl.rows
  for (var i = 1; i < tbl.rowCount(); ++i) {
    var args = []
	for (var j = 0; j < tbl.columnCount(); ++j)
	  args.push(rows[i].cells[j])
	res.push(f(...args))
  }
  return res
}

/// Checks whether a sheet, document or table is valid.
function checkValid(x, errorMsg) {
  try { x.name() }
  catch (err) { throw errorMsg }
}

/// Converts a Numbers table with formula values to a JavaScript map.
/// @param tbl A table with two columns (key and value).
function toFormulaMap(tbl, headerRows = 1) {
  var res = {}
  var rows = tbl.rows
  for (var i = headerRows; i < tbl.rowCount(); ++i)
    res[rows[i].cells[0].value()] = rows[i].cells[1].formula()
  return res
}

/// Converts a Numbers table to a JavaScript map.
/// @param tbl A table with two columns (key and value).
function columnsToList(tbl, firstColumn, numColumns, headerRows = 1) {
  var res = []
  var rows = tbl.rows
  for (var i = headerRows; i < tbl.rowCount(); ++i) {
    var tmp = []
	for (var j = firstColumn; j < (firstColumn + numColumns); ++j) {
      var content = rows[i].cells[j].formula()
	  if (content)
        tmp.push(content)
	  else
        tmp.push(rows[i].cells[j].value())
	}
	res.push(tmp)
  }
  return res
}

/// Converts a column of a Numbers table to a JavaScript list.
function columnToList(tbl, column, headerRows = 1) {
  var res = []
  var rows = tbl.rows
  for (var i = headerRows; i < tbl.rowCount(); ++i) {
    var content = rows[i].cells[column].formula()
	if (content)
      res.push(content)
	else
      res.push(rows[i].cells[column].value())
  }
  return res
}

function main() {
  // Check whether 'Numbers' is running.
  var ns = Application('Numbers')
  if (!ns.running())
    throw 'Numbers is not running'
  // Check whether 'Numbers' has at least one open document.
  if (ns.documents.length == 0)
    throw 'Numbers has no open document'
  // Fetch current document.
  var doc = ns.documents[0]
  checkValid(doc, 'Cannot access document')
  // Fetch configuration sheet from document.
  var configSheet = doc.sheets['Config']
  checkValid(configSheet, 'Cannot access "Config" sheet')
  // Read account names.
  var accountsTable = configSheet.tables['Accounts']
  checkValid(accountsTable, 'Cannot access "Accounts" table')
  var accounts = columnToList(accountsTable, 0, 0)
  // Read default keys for each account.
  var defaultsTable = configSheet.tables['Defaults']
  checkValid(defaultsTable, 'Cannot access "Defaults" table')
  var defaults = toFormulaMap(defaultsTable)
  // Read assignment rules.
  var rulesTable = configSheet.tables['Rules']
  checkValid(rulesTable, 'Cannot access "Rules" table')
  var rules = columnsToList(rulesTable, 0, 2)
  // Get all transaction keys.
  var keysTable = configSheet.tables['keys']
  checkValid(keysTable, 'Cannot access "keys" table')
  var keys = columnsToList(keysTable, 0, 1)
  // Collects all spendings by category.
  var spendings = {}
  var specialBudget = {}
  // Initialize spendings and specialBudgets with Key -> [MonthlyBalance].
  keys.forEach(key => {
    spendingMonths = []
	specialBudgetMonths = []
	for (var i = 0; i < 12; ++i) {
	  spendingMonths.push(0)
	  specialBudgetMonths.push(0)
	}
    spendings[key] = spendingMonths
	specialBudget[key] = specialBudgetMonths
  })
  // Traverse all accounts.
  accounts.forEach(account => {
    console.log('Process account ' + account)
    // Select the account sheet.
    var accountSheet = doc.sheets[account]
    checkValid(accountSheet, 'Cannot access "' + account + '" sheet')
	// Get the account table.
	var tbl = accountSheet.tables['Activity']
    checkValid(tbl, 'Cannot access "Activity" table')
	// Fallback key for this account.
    var fallback = defaults[account]
	// Traverse all rows.
	for (var i = 1; i < tbl.rowCount(); ++i) {
	  // Try to assign a key to all entries with an empty cell.
	  var rowKey = tbl.rows[i].cells[3].value()
	  if (!rowKey) {
	    var rowRef = tbl.rows[i].cells[2].value().toLowerCase()
		// Scan whether any of our rules apply.
		var entry = rules.find(rule => {
		  return rowRef.indexOf(rule[0]) != -1
		})
		if (entry != undefined) {
		  rowKey = entry[1]
		} else if (fallback != undefined) {
		  rowKey = fallback
		}
		if (rowKey) {
		  tbl.rows[i].cells[3].value = rowKey
		  // Reading the value back converts fallbacks such as '=Keys::$A6' to the referred value.
		  rowKey = tbl.rows[i].cells[3].value()
		}
	  }
	  // Store the transaction.
	  if (rowKey) {
	    // Javascript tries to be too clever when getting a Date from Numbers by converting to current time zone, potentially changing the day!
		// We work around this mess by getting the date as string and then parsing it again via JavaScript.
	    var date = new Date(tbl.rows[i].cells[0].formattedValue())
		var amount = tbl.rows[i].cells[1].value()
		if (amount < 0)
	  	  spendings[rowKey][date.getMonth()] += -amount
		else
		  specialBudget[rowKey][date.getMonth()] += amount
	  }
	}
  })
  // Fetch the budget table.
  var budgetSheet = doc.sheets['Budget']
  checkValid(budgetSheet, 'Cannot access "Budget" sheet')
  var budgetTable = budgetSheet.tables['Budget']
  checkValid(budgetTable, 'Cannot access "Budget" table')
  // Fill in calculated spendings.
  for (var i = 1; i < budgetTable.rowCount(); ++i) {
    var rowKey = budgetTable.rows[i].cells[0].value()
	var rowSubkey = budgetTable.rows[i].cells[1].value()
    if (rowSubkey == 'Spendings') {
      var months = spendings[rowKey]
	  if (months) {
        for (var j = 0; j < 12; ++j) {
	      budgetTable.rows[i].cells[j + 2].value = months[j].toFixed(2)
	    }
      }
	} else if (rowSubkey == 'Special Budget') {
      var months = specialBudget[rowKey]
	  if (months) {
        for (var j = 0; j < 12; ++j) {
	      budgetTable.rows[i].cells[j + 2].value = months[j].toFixed(2)
	    }
      }
	}
  }
}

try {
  main()
}
catch (err) {
  var msg = err.toString()
  if (msg != 'Error: User canceled.')
    ctx.displayDialog(err.toString(), {
      withIcon: 'caution',
	  buttons: ['Ok'],
    })
}
                              &jscr  ��ޭ