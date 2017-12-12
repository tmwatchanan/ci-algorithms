% calculation
desired_outputs = round(d_output);
actual_outputs = round(y_output);
confusion_matrix = zeros(NUM_CLASSES);
for i = 1:size(desired_outputs, 1)
  [_, d_idx] = max(desired_outputs(i, :));
  [_, c_idx] = max(actual_outputs(i, :));
  confusion_matrix(d_idx, c_idx) = confusion_matrix(d_idx, c_idx) + 1;
%  confusion_matrix(NUM_CLASSES - d_idx + 1, c_idx) = confusion_matrix(NUM_CLASSES - d_idx + 1, c_idx) + 1;
endfor
%wrong = sum(confusion_matrix(~logical(eye(size(confusion_matrix)))));
%accuracy = 1 - (wrong / fold_size);
correct = sum(confusion_matrix(logical(eye(size(confusion_matrix)))));
accuracy = correct / fold_size;

% flip confusion_matrix up-down for plot
confusion_matrix = flipud(confusion_matrix);

% plot
%figure('Position',[0,0,500,300]);
subplot(1,2,CONFUSION_MATRIX_SUBPLOT_POSITION)
hold on;
h = imagesc(confusion_matrix);            %# Create a colored plot of the matrix values
%colormap(flipud(gray));  %# Change the colormap to gray (so higher values are black and lower values are white)
%colormap(white);
textStrings = num2str(confusion_matrix(:),'%d');  %# Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  %# Remove any space paddingB
[x,y] = meshgrid(1:NUM_CLASSES);   %# Create x and y coordinates for the strings
text(x(:),y(:),textStrings(:),'HorizontalAlignment','center', 'fontsize', 18, 'fontweight', 'bold', 'fontname', 'Consolas');
%midValue = mean(get(gca,'CLim'));  %# Get the middle value of the color range
%textColors = repmat(confusion_matrix(:) > midValue,1,3);  %# Choose white or black for the text color of the strings so they can be easily seen over the background color
%set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors
set(gca,'fontsize', 10,...
        'XTick',1:NUM_CLASSES,...       %# Change the axes tick marks
        'XTickLabel',1:NUM_CLASSES,...  %#   and tick labels
        'YTick',1:NUM_CLASSES,...
        'YTickLabel',NUM_CLASSES:-1:1,...
        'TickLength',[0 0]);
text(x(:),y(:),textStrings(:),'HorizontalAlignment','center', 'fontsize', 18, 'fontweight', 'bold', 'fontname', 'Consolas');
axis("image");
text(x(:),y(:),textStrings(:),'HorizontalAlignment','center', 'fontsize', 18, 'fontweight', 'bold', 'fontname', 'Consolas');
xlabel('calculated class', 'fontsize', 9);
text(x(:),y(:),textStrings(:),'HorizontalAlignment','center', 'fontsize', 18, 'fontweight', 'bold', 'fontname', 'Consolas');
ylabel('desired class', 'fontsize', 9);
text(x(:),y(:),textStrings(:),'HorizontalAlignment','center', 'fontsize', 18, 'fontweight', 'bold', 'fontname', 'Consolas');
title([FILE_NAME ' ' CONFUSION_MATRIX_NAME ;'N=' num2str(NUM_CHROMOSOMES) ', p_m=' num2str(MUTATION_RATE) ', #hNodes=' numHiddenNodesForString; 'fold=' num2str(k) ', #generation=' num2str(generation) ; ' accuracy=' num2str(accuracy)]);
text(x(:),y(:),textStrings(:),'HorizontalAlignment','center', 'fontsize', 18, 'fontweight', 'bold', 'fontname', 'Consolas');
hold off;

if SAVE_FIGURES & strcmp(CONFUSION_MATRIX_NAME, 'Validation Set')
  SAVE_FILENAME = ["k" num2str(k) ".png"];
  if !exist(SAVE_DIRNAME, 'dir')
    mkdir(SAVE_DIRNAME);
  endif
%  text(x(:),y(:),textStrings(:),'HorizontalAlignment','center', 'fontsize', 18, 'fontweight', 'bold', 'fontname', 'Consolas');
  print([SAVE_DIRNAME '\' SAVE_FILENAME],'-dpng', '-S500,180');
  if !OPEN_FIGURES
    close(gcf)
  endif
endif
