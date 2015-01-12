CBETA_TAFxml
============

以「量化語言統計」為目的之簡化版漢文佛典 XML，由 CBETA XML P5 (https://github.com/cbeta-org/xml-p5.git) 經程式轉出。

專案主持人：洪振洲  
轉換程式撰寫：周邦信  
法鼓佛教學院

XML 資料格式簡介

| 標記  | 意義  | 使用規範 |
|---|---|---|
| <ab>  | 用來紀錄文獻內的文字內
容。對映至原文獻之<p>（純
散文）、<lg>（韻文、偈頌）
<p type="dharani">（咒語）。
對於卷的結構，僅改用<ab
type=”juan”>表示卷起始、結
束之資訊  | <ab type="prose"> 散文 </ab>（原<p>）
<ab type="verse"> 韻文</ab> (偈頌, 原 <lg>)
<ab type="dharani"> 咒語</ab> (原<p type="dharani">)
<ab type="juan">佛說長阿含經卷第十七</ab>（表示卷
起始、結束之資訊）  |
| <body>  |   |   |
| <byline>  |   |   |
| <div>  |   |   |
| <head> |   |   |
| <lb>  |   |   |
