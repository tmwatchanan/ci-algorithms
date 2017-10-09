if OPEN_FIGURES
  figure;
  axis("image")
  set(0, 'defaulttextfontsize', 14)
  hL = zeros(K_fold, 1);
  cmap = jet(K_fold);
  for ik = 1:K_fold
    hL(ik) = plot(1:size(avErrors{ik}, 2), avErrors{ik}, 'LineWidth', 3, 'Color', cmap(ik, :));
    hold on;
    xlabel('Epoch');
    ylabel('Error');
  endfor
  hold off;
  set(gca,'fontsize', 14);
  legend(hL, 'fold=1','fold=2','fold=3','fold=4','fold=5','fold=6','fold=7','fold=8','fold=9','fold=10');
  title([FILE_NAME ' training errors';'\eta=' num2str(LEARNING_RATE) ', \alpha=' num2str(MOMENTUM)]);
  if SAVE_FIGURES
    SAVE_ERRORS_FILENAME = [FILE_NAME "-lr" num2str(LEARNING_RATE) "-mo" num2str(MOMENTUM) "-errors.png"];
    print(SAVE_ERRORS_FILENAME,'-dpng'); % '-S800,500'
  endif
endif