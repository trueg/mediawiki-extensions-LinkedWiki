-- @copyright (c) 2016 Bourdercloud.com
-- @author Karima Rafes <karima.rafes@bordercloud.com>
-- @link http://www.mediawiki.org/wiki/Extension:LinkedWiki
-- @license CC-by-nc-sa V3.0
--
--  Last version : http://github.com/BorderCloud/LinkedWiki
--
--
-- This work is licensed under the Creative Commons
-- Attribution-NonCommercial-ShareAlike 3.0
-- Unported License. To view a copy of this license,
-- visit http://creativecommons.org/licenses/by-nc-sa/3.0/
-- or send a letter to Creative Commons,
-- 171 Second Street, Suite 300, San Francisco,
-- California, 94105, USA.

--[[
-- Debug console

mw.log(p.tests() )
]]

local p = {}

function p.checkLitteral(query, litteral)
    local result = ''
    if string.match(query, litteral) then
        result = "OK"
    else
        result = "KO"
    end
    return result
end


function p.checkString(val1, val2)
    local result = ''
    if (val1 ==  nil or val2 ==  nil) then
        result = "KO"
    else
        if val1 ==  val2 then
            result = "OK"
        else
            result = "KO"
        end
    end
    return result
end
function p.checkNumber(val1, val2)
    local result = ''
    if (val1 ==  nil or val2 ==  nil) then
        result = "KO"
    else
        if tonumber(val1) ==  tonumber(val2) then
            result = "OK"
        else
            result = "KO"
        end
    end
    return result
end


function p.tests(f)

    local linkedwiki = require 'linkedwiki'
    local endpoint = 'http://database-test:8890/sparql'
    local config = 'http://database-test'


    local xsd = 'http://www.w3.org/2001/XMLSchema#'

    local pr = 'http://database-test/Property:'

    local html = '== TESTS =='.. '\n'

    linkedwiki.setDebug(true)

    html = html .."TEST : linkedwiki.getCurrentIRI()" .. '\n'
    html = html .."RESULT : " .. linkedwiki.getCurrentIRI() .. '\n'

    linkedwiki.setConfig(config)

    local subject = linkedwiki.getCurrentIRI();


    html = html .."----------------------------------------------------------------------------" ..'\n'
    html = html .."TEST : linkedwiki.explode" ..'\n'

    local str1 = ""
    local str2 = "el1"
    local str3 = "el1;el2"
    local arrTestExplode1 = linkedwiki.explode(";",str1)
    local arrTestExplode2 = linkedwiki.explode(";",str2)
    local arrTestExplode3 = linkedwiki.explode(";",str3)
    html = html .."RESULT : 0==" ..table.getn(arrTestExplode1).. ' \n'
    html = html .."RESULT : 1==" ..table.getn(arrTestExplode2).. ' \n'
    html = html .."RESULT : 2==" ..table.getn(arrTestExplode3).. ' \n'

    html = html .."----------------------------------------------------------------------------" ..'\n'
    html = html .."TEST : getValue & addPropertyWithIri without default subject" ..'\n'

    mw.log(linkedwiki.removeSubject(subject))

    html = html .."Insert " .. pr..'Test'..'\n'
    mw.log(linkedwiki.addPropertyWithIri(pr..'type',pr..'Test',subject))
    local tabStr = linkedwiki.getValue(pr..'type',subject)
--    mw.log(linkedwiki.getLastQuery())
    local arr = linkedwiki.explode(";",tabStr)
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple\n'
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr), 1).. ' \n'

--    html = html .."RESULT : " ..tabStr.. '\n'
--
--    for i, iri in ipairs(arr) do
--        html = html .. i .. " : " .. iri .. '\n'
--    end

    html = html .."Insert " .. pr..'Test2'..'\n'
    mw.log(linkedwiki.addPropertyWithIri(pr..'type',pr..'Test2',subject))
    local tabStr2 = linkedwiki.getValue(pr..'type',subject)
--    mw.log(linkedwiki.getLastQuery())
    local arr2 = linkedwiki.explode(";",tabStr2)
    html = html .."RESULT : Found " ..table.getn(arr2).. ' triple\n'
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr2), 2).. ' \n'
--    html = html .."RESULT : " ..tabStr2.. '\n'
--
--    for i, iri in ipairs(arr2) do
--        html = html .. i .. " : " .. iri .. '\n'
--    end

    html = html .."TEST : removeSubject" ..'\n'
    mw.log(linkedwiki.removeSubject(subject))
    local tabStr3 = linkedwiki.getValue(pr..'type',subject)
--    mw.log(linkedwiki.getLastQuery())
    local arr3 = linkedwiki.explode(";",tabStr3)
    html = html .."RESULT : Found " ..table.getn(arr3).. ' triple\n'
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr3), 0).. ' \n'
--    html = html .."RESULT : " ..tabStr3.. '\n'
--
--    for i, iri in ipairs(arr3) do
--        html = html .. i .. " : " .. iri .. '\n'
--    end

    html = html .."----------------------------------------------------------------------------" ..'\n'
    html = html .."TEST : getValue & addPropertyWithIri with default subject" ..'\n'

    linkedwiki.setSubject(subject)
    linkedwiki.removeSubject() -- delete all triples of this subject

    html = html .."Insert " .. pr..'Test'..'\n'
    mw.log(linkedwiki.addPropertyWithIri(pr..'type',pr..'Test'))
    local arr = linkedwiki.explode(";",linkedwiki.getValue(pr..'type'))
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple\n'
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr), 1).. ' \n'

    html = html .."Insert " .. pr..'Test2'..'\n'
    mw.log(linkedwiki.addPropertyWithIri(pr..'type',pr..'Test2'))
    local arr2 = linkedwiki.explode(";",linkedwiki.getValue(pr..'type'))
    html = html .."RESULT : Found " ..table.getn(arr2).. ' triple\n'
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr2), 2).. ' \n'

    html = html .."TEST : removeSubject" ..'\n'
    mw.log(linkedwiki.removeSubject())
    local arr3 = linkedwiki.explode(";",linkedwiki.getValue(pr..'type'))
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr3), 0).. ' \n'

    html = html .."----------------------------------------------------------------------------" ..'\n'
    html = html .."TEST : getValue & addPropertyWithLitteral" ..'\n'

    --linkedwiki.addPropertyWithLitteral(iriProperty, value, type, tagLang, iriSubject)
    --default lang is en in extension.json
    local pT =''
    local litteral=''
    local query=''
    local result = ""
    local arr = {}


    html = html .."----------------------------------------------------------------------------" ..'\n'
    html = html .."TEST : text with lang tag " ..'\n'

    pT = pr..'1'
    litteral='\"\"\"text\"\"\"@en'
    html = html ..'Call Linkedwiki.addPropertyWithLitteral('..pT..',"text")'..'\n'
    html = html .."Insert text === "..litteral..'\n'
    mw.log(linkedwiki.addPropertyWithLitteral(pT,"text"))
    query= linkedwiki.getLastQuery()
    --mw.log(query)
    html = html .."RESULT : " .. p.checkLitteral(query,litteral) ..'\n'
    arr = linkedwiki.explode(";",linkedwiki.getValue(pT))
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple\n'
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr), 1).. ' \n'

    pT = pr..'2'
    litteral='\"\"\"text\"\"\"@en'
    html = html ..'Call Linkedwiki.addPropertyWithLitteral('..pT..',"text",nil)'..'\n'
    html = html .."Insert "..litteral..'\n'
    mw.log(linkedwiki.addPropertyWithLitteral(pT,"text",nil))
    query= linkedwiki.getLastQuery()
    --mw.log(query)
    html = html .."RESULT : " .. p.checkLitteral(query,litteral) ..'\n'
    arr = linkedwiki.explode(";",linkedwiki.getValue(pT))
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple\n'
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr), 1).. ' \n'

    pT = pr..'3'
    litteral='\"\"\"text\"\"\"@fr'
    html = html ..'Call Linkedwiki.addPropertyWithLitteral('..pT..',"text",nil,"fr")'..'\n'
    html = html .."Insert "..litteral..'\n'
    mw.log(linkedwiki.addPropertyWithLitteral(pT,"text",nil,"fr"))
    query= linkedwiki.getLastQuery()
    --mw.log(query)
    html = html .."RESULT : " .. p.checkLitteral(query,litteral) ..'\n'
    arr = linkedwiki.explode(";",linkedwiki.getValue(pT))
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple\n'
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr), 1).. ' \n'

    pT = pr..'4'
    litteral='\"\"\"text\"\"\"'
    html = html ..'Call Linkedwiki.addPropertyWithLitteral('..pT..',"text",nil,"")'..'\n'
    html = html .."Insert "..litteral..'\n'
    mw.log(linkedwiki.addPropertyWithLitteral(pT,"text",nil,""))
    query= linkedwiki.getLastQuery()
    mw.log(query)
    html = html .."RESULT : " .. p.checkLitteral(query,litteral) ..'\n'
    arr = linkedwiki.explode(";",linkedwiki.getValue(pT))
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple\n'
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr), 1).. ' \n'

    pT = pr..'5'
    litteral='\"\"\"text\"\"\"'
    html = html ..'Call Linkedwiki.addPropertyWithLitteral('..pT..',"text",nil,nil)'..'\n'
    html = html .."Insert "..litteral..'\n'
    mw.log(linkedwiki.addPropertyWithLitteral(pT,"text",nil,nil))
    query= linkedwiki.getLastQuery()
    mw.log(query)
    html = html .."RESULT : " .. p.checkLitteral(query,litteral) ..'\n'
    arr = linkedwiki.explode(";",linkedwiki.getValue(pT))
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple\n'
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr), 1).. ' \n'

    pT = pr..'6'
    litteral='\"\"\"text\"\"\"'
    html = html ..'Call Linkedwiki.addPropertyWithLitteral('..pT..',"text",nil,nil)'..'\n'
    html = html .."Insert "..litteral..'\n'
    mw.log(linkedwiki.addPropertyWithLitteral(pT,"text",nil,nil))
    query= linkedwiki.getLastQuery()
    mw.log(query)
    html = html .."RESULT : " .. p.checkLitteral(query,litteral) ..'\n'
    arr = linkedwiki.explode(";",linkedwiki.getValue(pT))
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple\n'
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr), 1).. ' \n'

    html = html .."TEST : removeSubject" ..'\n'
    mw.log(linkedwiki.removeSubject())


    html = html .."----------------------------------------------------------------------------" ..'\n'
    html = html .."TEST : integer" ..'\n'

    pT = pr..'7'
    litteral='2'
    html = html ..'Call Linkedwiki.addPropertyWithLitteral('..pT..',2)'..'\n'
    html = html .."Insert "..litteral..'\n'
    mw.log(linkedwiki.addPropertyWithLitteral(pT,2))
    query= linkedwiki.getLastQuery()
    mw.log(query)
    html = html .."RESULT : " .. p.checkLitteral(query,litteral) ..'\n'
    arr = linkedwiki.explode(";",linkedwiki.getValue(pT))
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple\n'
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr), 1).. ' \n'

    html = html .."TEST : removeSubject" ..'\n'
    mw.log(linkedwiki.removeSubject())

    html = html .."----------------------------------------------------------------------------" ..'\n'
    html = html .."TEST : decimal" ..'\n'

    pT = pr..'8'
    litteral='"2"^^<'..xsd.."decimal"..'>'
    html = html ..'Call Linkedwiki.addPropertyWithLitteral('..pT..',2,xsd.."decimal")'..'\n'
    html = html .."Insert "..litteral..'\n'
    mw.log(linkedwiki.addPropertyWithLitteral(pT,2,xsd.."decimal"))
    query= linkedwiki.getLastQuery()
    mw.log(query)
    html = html .."RESULT : " .. p.checkLitteral(query,litteral) ..'\n'
    arr = linkedwiki.explode(";",linkedwiki.getValue(pT))
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple\n'
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr), 1).. ' \n'
    html = html .."RESULT : " ..p.checkNumber(arr[1], 2).. ' \n'
    html = html .."TEST : removeSubject" ..'\n'
    mw.log(linkedwiki.removeSubject())


    pT = pr..'9'
    litteral='2.1'
    html = html ..'Call Linkedwiki.addPropertyWithLitteral('..pT..',2.1)'..'\n'
    html = html .."Insert "..litteral..'\n'
    mw.log(linkedwiki.addPropertyWithLitteral(pT,2.1))
    query= linkedwiki.getLastQuery()
    mw.log(query)
    html = html .."RESULT : " .. p.checkLitteral(query,litteral) ..'\n'

    arr = linkedwiki.explode(";",linkedwiki.getValue(pT))
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple\n'
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr), 1).. ' \n'
    html = html .."RESULT : " ..p.checkNumber(arr[1], 2.1).. ' \n'
    html = html .."TEST : removeSubject" ..'\n'
    mw.log(linkedwiki.removeSubject())

    pT = pr..'10'
    litteral='"2.1"^^<'..xsd.."decimal"..'>'
    html = html ..'Call Linkedwiki.addPropertyWithLitteral('..pT..',2.1,xsd.."decimal")'..'\n'
    html = html .."Insert "..litteral..'\n'
    mw.log(linkedwiki.addPropertyWithLitteral(pT,2.1,xsd.."decimal"))
    query= linkedwiki.getLastQuery()
    mw.log(query)
    html = html .."RESULT : " .. p.checkLitteral(query,litteral) ..'\n'

    arr = linkedwiki.explode(";",linkedwiki.getValue(pT))
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple\n'
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr), 1).. ' \n'
    html = html .."RESULT : " ..p.checkNumber(arr[1], 2.1).. ' \n'


    html = html .."TEST : removeSubject" ..'\n'
    mw.log(linkedwiki.removeSubject())

    html = html .."----------------------------------------------------------------------------" ..'\n'
    html = html .."TEST : without default subject" ..'\n'

    local subject2 = linkedwiki.getCurrentIRI().."2";

    pT = pr..'11'
    litteral='2'
    html = html ..'Call  Linkedwiki.addPropertyWithLitteral('..pT..',2,nil,nil,subject2)'..'\n'
    html = html .."Insert "..litteral..'\n'
    mw.log(linkedwiki.addPropertyWithLitteral(pT,2,nil,nil,subject2))
    query= linkedwiki.getLastQuery()
    mw.log(query)
    html = html .."RESULT : " .. p.checkLitteral(query,litteral) ..'\n'
    arr = linkedwiki.explode(";",linkedwiki.getValue(pT,subject2))
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple\n'
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr), 1).. ' \n'
    html = html .."RESULT : " ..p.checkNumber(arr[1], 2).. ' \n'


    html = html .."TEST : removeSubject" ..'\n'
    mw.log(linkedwiki.removeSubject())

    html = html .."----------------------------------------------------------------------------" ..'\n'
    html = html .."TEST : text with lang tag + function getString" ..'\n'
    --linkedwiki.getString(iriProperty, tagLang, iriSubject)

    pT = pr..'12'
    html = html ..'Call Linkedwiki.addPropertyWithLitteral('..pT..',"text")'..'\n'
    html = html ..'Call Linkedwiki.addPropertyWithLitteral('..pT..',"text2",nil,"fr")'..'\n'
    mw.log(linkedwiki.addPropertyWithLitteral(pT,"text"))
    mw.log(linkedwiki.addPropertyWithLitteral(pT,"text2",nil,"fr"))
    --query= linkedwiki.getLastQuery()
    --mw.log(query)
    arr = linkedwiki.explode(";",linkedwiki.getValue(pT))
    html = html .."RESULT : Found " ..table.getn(arr).. ' triple\n'
    html = html .."RESULT : " ..p.checkNumber(table.getn(arr),2).. ' \n'
    html = html .."RESULT : " ..p.checkString(linkedwiki.getString(pT), "text").. ' \n'
    html = html .."RESULT : " ..p.checkString(linkedwiki.getString(pT,"en"), "text").. ' \n'
    html = html .."RESULT : " ..p.checkString(linkedwiki.getString(pT,"fr"), "text2").. ' \n'
    html = html .."RESULT : " ..p.checkString(linkedwiki.getString(pT,"fr",subject), "text2").. ' \n'


    html = html .."TEST : removeSubject" ..'\n'
    mw.log(linkedwiki.removeSubject())


    return "<nowiki><pre>"..mw.text.encode( html).."</pre></nowiki>"
end

return p