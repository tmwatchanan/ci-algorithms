input_file_name = "wdbc.data";
output_file_name = [strsplit(input_file_name, ".")(1) "-numeric." strsplit(input_file_name, ".")(2)];
output_file_name = [output_file_name{:}];
wdbc_fid = fopen (input_file_name, "r");
output_fid = fopen (output_file_name, "w");

line = fgetl(wdbc_fid);
while (line != -1)
  splited_line = strsplit (line, ",");
  if any(line == "B")
    splited_line(1) = "1";
    splited_line(2) = "0";
  elseif any(line == "M")
    splited_line(1) = "0";
    splited_line(2) = "1";
  else
    error("Invalid specific classes");
  endif
  joined_line = strjoin (splited_line, ',');
  fdisp(output_fid, joined_line);
  line = fgetl(wdbc_fid);
endwhile

fclose(wdbc_fid);
fclose(output_fid);
