CBETA_TAFxml
============

以「量化語言統計」為目的之簡化版漢文佛典 XML，由 CBETA XML P5 (https://github.com/cbeta-org/xml-p5.git) 經程式轉出。

專案主持人：洪振洲  
轉換程式撰寫：周邦信  
法鼓佛教學院

資料更新紀錄：
- 2019.02.22 以當時最新 CBETA XMP P5，進行本資料集更新，並新增CBETA收錄之卍續藏(X)與嘉興藏(J)資料。


XML 資料格式簡介

| 標記  | 意義  | 使用規範 |
|---|---|---|
| &#x3C;ab&#x3E; | 用來紀錄文獻內的文字內容。<br> 對映至原文獻之&lt;p&gt;（純散文）、<br> &lt;lg&gt;（韻文、偈頌） &lt;p type=&quot;dharani&quot;&gt;（咒語）。<br> 對於卷的結構，僅改用<br> &lt;ab type=&rdquo;juan&rdquo;&gt;表示卷起始、結束之資訊 | &lt;ab type=&quot;prose&quot;&gt; 散文 &lt;/ab&gt;（原&lt;p&gt;） <br> &lt;ab type=&quot;verse&quot;&gt; 韻文&lt;/ab&gt; (偈頌, 原 &lt;lg&gt;) <br> &lt;ab type=&quot;dharani&quot;&gt; 咒語&lt;/ab&gt; <br> (原&lt;p type=&quot;dharani&quot;&gt;) <br> &lt;ab type=&quot;juan&quot;&gt;佛說長阿含經卷第十七&lt;/ab&gt;<br>（表示卷 起始、結束之資訊） |
| &#x3C;body&#x3E;  | TEI 文件內容容器  | 與原有CBETA XML、TEI P5 規範使用方式相同  |
| &#x3C;byline&#x3E;  | 用保留譯者資訊  | &lt;byline&gt;長安釋僧肇述&lt;/byline&gt;  |
| &#x3C;div&#x3E;  |  用以表示文獻結構，以type與level 屬性表示文件所屬型態與階層 | &lt;div type=&quot;fen&quot; level=&quot;2&quot;&gt; 第二層div 結構，分&lt;/div&gt; <br> &lt;div type=&quot;pin &quot; level=&quot;3&quot;&gt; 第三層div 結構，品&lt;/div&gt;  |
| &#x3C;head&#x3E; | 置於各div 元素之下，紀錄各層次文字區塊之標題。  | &lt;head&gt;（一）第一分初大本經第一&lt;/head&gt;  |
| &#x3C;lb&#x3E; |  用以紀錄大正藏的行號資訊，以便作為原始資料之對應。 |  &lt;lb n=&quot;0114b06&quot; ed=&quot;T&quot;/&gt; |
