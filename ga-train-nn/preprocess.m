wdbc_fid = fopen ('wdbc.data', 'r');
output_fid = fopen ('wdbc_numeric.data', 'w');

line = fgetl(wdbc_fid);
while (line != -1)
  line(line == 'B') = '0';
  line(line == 'M') = '1';
  fdisp(output_fid, line);
  line = fgetl(wdbc_fid);
endwhile

fclose(wdbc_fid);
fclose(output_fid);