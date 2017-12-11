input_file_name = "wdbc.data";
output_file_name = [strsplit(input_file_name, ".")(1) "-numeric." strsplit(input_file_name, ".")(2)];
output_file_name = [output_file_name{:}];
wdbc_fid = fopen (input_file_name, "r");
output_fid = fopen (output_file_name, "w");

line = fgetl(wdbc_fid);
while (line != -1)
  line(line == "B") = "0";
  line(line == "M") = "1";
  fdisp(output_fid, line);
  line = fgetl(wdbc_fid);
endwhile

fclose(wdbc_fid);
fclose(output_fid);
