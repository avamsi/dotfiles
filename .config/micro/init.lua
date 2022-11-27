local config = import("micro/config")

function selectword(bp)
	bp.Cursor:SelectWord()
end

function init()
	config.MakeCommand("selectword", selectword, config.NoComplete)
end
