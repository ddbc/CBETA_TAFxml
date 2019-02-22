# CBETA XML 簡化版 格式說明

## Character Encoding

UTF-8

## 簡化版的 Elements

### ab
* `<ab type="prose">` 散文 (原多個 p 合成一個 ab)
* `<ab type="verse">` 韻文(偈頌, 原 `<lg>`)
* `<ab type="dharani">` 咒語 (原 `<p type="dharani">`)

### body

### byline

### div

* 保留 type 屬性, 加 level 屬性
* 如果 body 下有多個 div, 就在最外層再包一個 `<div level=”1”>`
* `<div type=”w”>`, `<div type=”xu”>` 都保留

### head

### juan
* `<juan fun="open">…</juan>` 轉為 `<ab type="juan" subtype="open">`
* `<juan fun="close">…</juan> 轉為 <ab type="juan" subtype="close">`

### pb
保留頁碼

### trailer
內容及標記均不轉出

## 特字
`<g>` 改為 Unicode PUA 字元，例如 `<g ref="#CB02596"/>` 轉為 `&#xF0A24;`。

## 去除 tag
`<div type=”other”>` 標記去除, 但是內容保留.

## 去除元素
back, docNumber, mulu, note, sic, teiHeader
