#   Copyright @2021 President and Fellows of Harvard College

#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#   http://www.apache.org/licenses/LICENSE-2.0

#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

require 'json'

def fix_bbox(bbox_string, layer, bad_file)
    list_nums=bbox_string.delete('ENVELOPE(').delete(')').split(',').to_a
    list_nums.map!(&:strip)
    if list_nums[0] == list_nums[1]
        bad_file.append(layer)
        size=list_nums[0].split("").size-1
        if list_nums[0].to_f>=0
            if size ==1
                list_nums[1]=list_nums[1] + ".001"
            elsif size < 3
                list_nums[1]=list_nums[1] + "001"
            else
                list_nums[1]=list_nums[1]+"1"
            end
        else
            if size == 1
                list_nums[0]=list_nums[0] + ".001"
            elsif size < 3
                list_nums[0]=list_nums[0] + "001"
            else
                list_nums[0]=list_nums[0]+"1"
            end
        end
    end
    if list_nums[2] == list_nums[3]
        bad_file.append(layer)
        size=list_nums[2].split("").size-1
        if list_nums[2].to_f>=0
            if size ==1
                list_nums[2]=list_nums[2] + ".001"
            elsif size < 3
                list_nums[2]=list_nums[2] + "001"
            else
                list_nums[2]=list_nums[2]+"1"
            end
        else
            if size == 1
                list_nums[3]=list_nums[3] + ".001"
            elsif size < 3
                list_nums[3]=list_nums[3] + "001"
            else
                list_nums[3]=list_nums[3]+"1"
            end
        end
    end
    bbox_string="ENVELOPE(" + list_nums.join(", ") + ")"
    return bbox_string
end

file_list=Dir['/path/to/files/**/*.json']

for file in file_list
    bad_stuff=[]
    json_file=JSON.load(File.read(file))
    if json_file.key?("solr_geom")
        json_file["solr_geom"]=fix_bbox(json_file['solr_geom'], json_file['layer_id_s'], bad_stuff)
        if bad_stuff.include?(json_file['layer_id_s'])
	        puts 'writing new file'
            puts json_file['layer_id_s']
            File.open(file, 'w') { |f| f.write(json_file.to_json) }
        end
    end
    changes = File.open('/path/to/files/fixed.txt', 'a')
    bad_stuff=bad_stuff.uniq
    for item in bad_stuff
        changes.write(item.to_s + "\n")
    end
end
