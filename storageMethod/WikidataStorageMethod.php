<?php

/**
 * @copyright (c) 2018 Bourdercloud.com
 * @author Karima Rafes <karima.rafes@bordercloud.com>
 * @link https://www.mediawiki.org/wiki/Extension:LinkedWiki
 * @license CC-by-sa V4.0
 *
 *  Last version: https://github.com/BorderCloud/LinkedWiki
 *
 *
 * This work is licensed under the Creative Commons
 * Attribution-NonCommercial-ShareAlike 3.0
 * Unported License. To view a copy of this license,
 * visit http://creativecommons.org/licenses/by-nc-sa/3.0/
 * or send a letter to Creative Commons,
 * 171 Second Street, Suite 300, San Francisco,
 * California, 94105, USA.
 */
class WikidataStorageMethod extends StorageMethodAbstract
{

    public function getQueryReadStringWithTagLang()
    {
        return <<<EOT
SELECT DISTINCT  ?value
WHERE
        {
            ?subject ?property ?value .
            FILTER ( lang(?value) = ?lang )
        }
EOT;
    }

    public function getQueryReadStringWithoutTagLang()
    {
        return <<<EOT
SELECT DISTINCT  ?value
WHERE
        {
            ?subject ?property ?value .
            FILTER ( lang(?value) = "" )
        }
EOT;
    }

    public function getQueryReadValue()
    {
        return <<<EOT
SELECT DISTINCT  ?value
WHERE
        {
            ?subject ?property ?value .
        }
EOT;
    }

    public function getQueryInsertValue()
    {
        return "";
    }

    public function getQueryDeleteSubject()
    {
        return "";
    }

    public function getQueryLoadData($url)
    {
        return "";
    }

}
