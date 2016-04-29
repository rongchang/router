require 'yaml'
require 'erb'
require 'logger'
require 'fileutils'

@replace_mark = '-replace-'
@config_file_name = "replace_config.yml"
@log_name = "replace.log"

@path = ARGV[0]
@path ||= Dir.pwd
# Logger.new(STDOUT).info @path

@backup_path = "#{@path}/backup"
@config_file_path = "#{@path}/#{@config_file_name}"
@log_path = "#{@path}/#{@log_name}"

# `rm #{@log_path}`
@logger = Logger.new(@log_path)



def replace target, data, file_path, action

  @logger.info %Q(#{action}: #{target} with: #{data} )

  target = target.gsub('"','\"').split(@replace_mark)

  match = target.join ".*"

  match_res = `sed -n "/#{match}/p" #{file_path}`
  if match_res.size > 0

    case action
    when 'replace'
      data = [data] if data.class != Array
      replacer = ''
      target.each_with_index do |v,i|
        replacer << v
        replacer << data[i] if data[i]
      end
      `sed -i "s/#{match}/#{replacer}/" #{file_path}`
      @logger.info "Found and replaced: #{match_res}"
    when 'replace_line'
      replacer = data
      `sed -i "s/#{match}/#{replacer}/" #{file_path}`
      @logger.info "Found and replaced line: #{match_res}"
    when 'delete'
      `sed -i "/#{match}/d" #{file_path}`
      @logger.info "Found and deleted: #{match_res}"
    when 'append'
      replacer = data
      `sed -i "/#{match}/a #{replacer}" #{file_path}`
      @logger.info "Found and appended: #{match_res}"
    end
  else
    @logger.info "Target not found"
  end
end

def backup_files path
  t_path = "#{@backup_path}#{path}"
  if File.exists? t_path
    FileUtils.cp t_path, path
    @logger.info "Recovering #{path}"
  else
    FileUtils.mkpath File.dirname(t_path)
    FileUtils.cp path, t_path
    @logger.info "Backing up #{path}"
  end
end


config_changes = YAML.load(ERB.new(File.read(@config_file_path)).result)
config_changes = config_changes['files']

config_changes.each do |i|
  path = i['path']
  @logger.info "---  Editing: #{path}  ---"
  backup_files path
  i['task'].each do |j|
    replace j['target'], j['value'], path, j['type']
  end
end
