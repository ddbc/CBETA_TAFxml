CBETA_TAFxml
============

以「量化語言統計」為目的之簡化版漢文佛典 XML，由 CBETA XML P5 (https://github.com/cbeta-org/xml-p5.git) 經程式轉出。

專案主持人：洪振洲  
轉換程式撰寫：周邦信  
法鼓佛教學院

XML 資料格式簡介

| 標記  | 意義  | 使用規範 |
|---|---|---|
| &#x3C;ab&#x3E; | 用來紀錄文獻內的文字內容。對映至原文獻之&lt;p&gt;（純散文）、&lt;lg&gt;（韻文、偈頌） &lt;p type=&quot;dharani&quot;&gt;（咒語）。對於卷的結構，僅改用&lt;ab type=&rdquo;juan&rdquo;&gt;表示卷起始、結束之資訊 | &lt;ab type=&quot;prose&quot;&gt; 散文 &lt;/ab&gt;（原&lt;p&gt;） &lt;ab type=&quot;verse&quot;&gt; 韻文&lt;/ab&gt; (偈頌, 原 &lt;lg&gt;) &lt;ab type=&quot;dharani&quot;&gt; 咒語&lt;/ab&gt; (原&lt;p type=&quot;dharani&quot;&gt;) &lt;ab type=&quot;juan&quot;&gt;佛說長阿含經卷第十七&lt;/ab&gt;（表示卷 起始、結束之資訊） |
| &#x3C;body&#x3E;  |   |   |
| &#x3C;byline&#x3E;  |   |   |
| &#x3C;div&#x3E;  |   |   |
| &#x3C;head&#x3E; |   |   |
| &#x3C;lb&#x3E; |   |   |
