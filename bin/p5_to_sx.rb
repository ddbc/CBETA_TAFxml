# 讀 CBETA P5 XML 轉出較簡單的 XML 供文獻分析使用
# 轉換規則見 simple-xml-rules.md
# 執行例:
#  轉大正藏第三冊: ruby p5_to_sx.rb T03
#  轉大正藏第三冊至第八冊: ruby p5_to_sx.rb T03..T08

require 'nokogiri'
require 'cbeta'

IN = '/Users/ray/git-repos/cbeta-xml-p5'
OUT = '../out'

# 內容不輸出的元素
PASS=['back', 'docNumber', 'mulu', 'note', 'teiHeader', 'trailer']

# 忽略下一層的 white space
IGNORE=['TEI', 'text']

# empty element
EMPTY = ['lb', 'pb']

def cb2pua(cb)
  if cb.start_with? 'CB'
    pua = cb[2..-1].to_i + 0xF0000
  elsif cb.start_with('SD')
    pua = cb[3..-1].to_i(16) + 0xFA000
  elsif cb.start_with('RJ')
    pua = cb[3..-1].to_i(16) + 0x100000
  end
  r = '&#x%X;' % pua
  $chars[cb] = r[3..-2] unless chars.key? cb
  r
end

class P5ToSimpleXML
  def initialize
    @ab_type = nil
    @div_level = 0
  end
  
  def e_body(e)
    r = ''
    divs = e.search('div')
    
    # 如果 body 下有多個 div, 在最外層再包一個大 div
    if divs.size > 1
      @div_level = 1
      r = "<div level='1'>\n" + traverse(e)
      r += close_ab + '</div>'
      @div_level = 0
    else
      # 如果 body 只有一個 div, 而這個 div 的 type 是 other, 
      # 這個 div 會被忽略, 所以還是要在最外層再包一個大 div
      div = e.at('div')
      if div['type'] == 'other'
        @div_level = 1
        r += "<div level='1'>\n" + traverse(e)
        r += close_ab + '</div>'
        @div_level = 0
      else
        r += traverse(e)
        r += close_ab
      end
    end
    r
  end
  
  def e_byline(e)
    '<byline>' + traverse(e) + '</byline>'
  end
  
  def e_div(e)
    r = ''
    if e['type'] == 'other'
      r += traverse(e)
    else
      @div_level += 1
      r = close_ab
      r += "<div type='#{e['type']}' level='#{@div_level}'>"
      r += traverse(e)
      r += close_ab
      @div_level -= 1
      r += '</div>'
    end
    r
  end
  
  def e_gaiji(e)
    r=''
    if e.key? 'uni'
      uni = e.get['uni']
      return [uni.hex].pack("U") if uni.match(/[\dA-F]+$/)
        
      tokens = uni.scan(/&#x(.*?);/)
      tokens.each do |t|
        next if t[0].empty?
        r += [t[0].hex].pack("U")
      end
      return r
    end
    
    if e.key? 'cx'
      cx = e['cx']
      tokens = cx.scan(/＆(CB04608)；/)
      tokens.each do |t|
        if t[0].start_with? 'CB'
          r += cb2pua(t)
        else
          puts "error 96: #{cs}"
          exit(1)
        end
      end
      return r
    end
    
    cb2pua(e['cb'])
  end
  
  def e_head(e)
    return '' if e['type'] == 'no'
    
    '<head>' + traverse(e) + '</head>'
  end
  
  def e_juan(e)
    r = "\n" + close_ab
    r += "<ab type='juan' subtype='#{e['fun']}'>"
    r += traverse(e) + '</ab>'
  end
  
  def e_lb(e)
    s = e.to_xml
    s.sub(/^<lb /, "<lb\n ")
  end
  
  def e_lg(e)
    r = open_ab('verse') + "\n"
    r += traverse(e)
    r += "\n" + close_ab
  end
  
  def e_p(e)
    r = ''
    if e['type'] == "dharani"
      r += open_ab("dharani")
    else
      r += open_ab("prose")
    end
    r + traverse(e)
  end
  
  def e_t(e)
    return '' if e['place'] == 'foot'
    
    traverse(e)
  end

  def handle_text(e)
    return '' if IGNORE.include? e.parent.name
    
    s = e.content().chomp
    return '' if s.empty?
    
    r = s.gsub("\n", '')
    r.gsub!('&', '&amp;')
    r.gsub!('<', '&lt;')
    r
  end

  def traverse(e)
    r = ''
    e.children.each { |c| 
      r += handle_node(c)
    }
    r
  end

  def open_ab(type)
    r = ''
    if @ab_type.nil?
      r = "<ab type='#{type}'>"
    elsif @ab_type != type
      r = "</ab>\n"
      r += "<ab type='#{type}'>"
    end
    @ab_type = type
    r
  end

  def close_ab
    r = ''
    unless @ab_type.nil?
      r = '</ab>'
      @ab_type = nil
    end
    r
  end
    
  def handle_node(e)
    return '' if e.comment?
    return handle_text(e) if e.text?
    return '' if PASS.include? e.name
    
    r = case e.name
    when 'body'   then e_body(e)
    when 'byline' then e_byline(e)
    when 'div'    then e_div(e)
    when 'gaiji'  then e_gaiji(e)
    when 'head'   then e_head(e)
    when 'juan'   then e_juan(e)
    when 'l'      then traverse(e) + '　　'
    when 'lb'     then e_lb(e)
    when 'lg'     then e_lg(e)
    when 'p'      then e_p(e)
    when 'pb'     then e.to_xml
    when 'rdg'    then ''
    when 't'      then e_t(e)
    else traverse(e)
    end
    r
  end  
end

def parse_xml(fn)
  s = File.read(fn)
  doc = Nokogiri::XML(s)
  doc.remove_namespaces!

  xt = P5ToSimpleXML.new
  
  e = doc.at('//title')
  title = xt.traverse(e)
  $title = title.split.last
  puts "title 是空的" if $title.empty?
  
  xt.traverse(doc.root)
end
  
def convert_sutra(folder_in, folder_out, sutra)
  fn = File.join(folder_in, sutra+'.xml')
  new_xml = parse_xml(fn)
  
  work_id = CBETA.get_work_id_from_file_basename(sutra)
  tei_header = $tei_header_template % {
    title: $title,
    vol: $vol,
    sutra_no: $sutra_no
  }
  new_xml = tei_header + new_xml
  new_xml += "\n</body></text></TEI>"
  
  fn = File.join(folder_out, work_id+'.xml')
  puts "write #{fn}"
  File.write(fn, new_xml)
end

def convert_vol(vol)
  puts "convert vol: #{vol}"
  $vol = vol
  canon = vol[0]
  dest = File.join(OUT, canon)
  Dir.mkdir(dest) unless Dir.exist? dest
    
  source = File.join(IN, canon, vol)
  Dir.entries(source).sort.each do |f|
    if f.end_with? '.xml'
      $sutra_no = File.basename(f, '.xml')
      convert_sutra(source, dest, $sutra_no)
    end
  end
end

def write_chars
  fn = File.join(OUT, 'chars.txt')
  fo = File.open(fn, 'w')
  fo.puts "# coding: utf8"
  fo.puts "#CB Code\tPUA Char\tPUA Code\n"
  $chars.keys.sort.each do |gid|
    pua = chars[gid]
    c = [pua.hex].pack("U")
    fo.puts "#{gid}\t#{c}\t#{pua}"
  end
  fo.close()
end

# main
$chars={}

$tei_header_template = File.read('header-template.txt')

Dir.mkdir(OUT) unless Dir.exist? OUT

arg = ARGV[0]
if arg.include? '..'
  v1, v2 = ARGV[0].split('..')

  canon = CBETA.get_canon_from_vol(v1)
  folder = File.join(IN, canon)
  Dir.entries(folder).sort.each do |vol|
    next if vol.start_with? '.'
    next if (vol < v1) or (vol > v2)
    convert_vol(vol)
  end
else
  convert_vol(arg.upcase)
end

write_chars