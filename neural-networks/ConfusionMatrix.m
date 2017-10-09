%figure(k);
%figure('Position',[0,0,500,300]);
subplot(1,2,CONFUSION_MATRIX_SUBPLOT_POSITION)
h = imagesc(confusion_matrix);            %# Create a colored plot of the matrix values
%colormap(flipud(gray));  %# Change the colormap to gray (so higher values are black and lower values are white)
%colormap(white);
textStrings = num2str(confusion_matrix(:),'%d');  %# Create strings from the matrix values
textStrings = strtrim(cellstr(textStrings));  %# Remove any space paddingB
[x,y] = meshgrid(1:NUM_CLASSES);   %# Create x and y coordinates for the strings
text(x(:),y(:),textStrings(:),'HorizontalAlignment','center', 'fontsize', 28, 'fontweight', 'bold', 'fontname', 'Consolas');

%midValue = mean(get(gca,'CLim'));  %# Get the middle value of the color range
%textColors = repmat(confusion_matrix(:) > midValue,1,3);  %# Choose white or black for the text color of the strings so they can be easily seen over the background color
%set(hStrings,{'Color'},num2cell(textColors,2));  %# Change the text colors
set(gca,'fontsize', 14,...
        'XTick',1:NUM_CLASSES,...       %# Change the axes tick marks
        'XTickLabel',1:NUM_CLASSES,...  %#   and tick labels
        'YTick',1:NUM_CLASSES,...
        'YTickLabel',1:NUM_CLASSES,...
        'TickLength',[0 0]);
%set(gca, 'Position', get(gca, 'OuterPosition') - get(gca, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]);
axis("image")
%set(gcf, 'PaperUnits', 'inches');
%set(gcf, 'PaperSize', [6.25 7.5]);
%set(gcf, 'PaperPositionMode', 'manual');
%set(gcf, 'PaperPosition', [0 0 6.25 7.5]);
%set(gcf, 'renderer', 'painters');        
text(x(:),y(:),textStrings(:),'HorizontalAlignment','center', 'fontsize', 28, 'fontweight', 'bold', 'fontname', 'Consolas');
xlabel('calculated class', 'fontsize', 14);
text(x(:),y(:),textStrings(:),'HorizontalAlignment','center', 'fontsize', 28, 'fontweight', 'bold', 'fontname', 'Consolas');
ylabel('desired class', 'fontsize', 14);
text(x(:),y(:),textStrings(:),'HorizontalAlignment','center', 'fontsize', 28, 'fontweight', 'bold', 'fontname', 'Consolas');
title([FILE_NAME ' ' CONFUSION_MATRIX_NAME ;'\eta=' num2str(LEARNING_RATE) ', \alpha=' num2str(MOMENTUM) ; 'fold=' num2str(k) ' accuracy=' num2str(accuracy)]);

text(x(:),y(:),textStrings(:),'HorizontalAlignment','center', 'fontsize', 28, 'fontweight', 'bold', 'fontname', 'Consolas');
SAVE_FILENAME = [FILE_NAME "-lr" num2str(LEARNING_RATE) "-mo" num2str(MOMENTUM) "-k" num2str(k) ".jpg"];
%print(SAVE_FILENAME,'-djpg');
%print(SAVE_FILENAME,'-djpg', '-S500,350');
%saveas (h, [FILE_NAME "-figure-new-" num2str(k) ".jpg"]);
