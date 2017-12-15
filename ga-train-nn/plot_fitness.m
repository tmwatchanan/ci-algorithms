if SAVE_FIGURES
  figure;
  axis("image")
  set(0, 'defaulttextfontsize', 14)
  hL = zeros(K_fold, 1);
  cmap = jet(K_fold);
  for ik = 1:K_fold
    hL(ik) = plot(1:size(average_fitness_of_k_fold{ik}, 2), average_fitness_of_k_fold{ik}, 'LineWidth', 3, 'Color', cmap(ik, :));
    hold on;
    xlabel('Generation');
    ylabel('Error');
  endfor
  hold off;
  set(gca,'fontsize', 14);
  legend(hL, 'fold=1','fold=2','fold=3','fold=4','fold=5','fold=6','fold=7','fold=8','fold=9','fold=10');
  title([FILE_NAME ' average fitness in training';'N=' num2str(NUM_CHROMOSOMES) ', Pm=' num2str(MUTATION_RATE) ', #hNodes=' numHiddenNodesForString]);
  if SAVE_FIGURES
    SAVE_FILENAME = "plot-average_fitness.png";
    if !exist(SAVE_DIRNAME, 'dir')
      mkdir(SAVE_DIRNAME);
    endif
    SAVE_ERRORS_FILENAME = [SAVE_DIRNAME '\' SAVE_FILENAME];
    print(SAVE_ERRORS_FILENAME,'-dpng'); % '-S800,500'
  endif
  if ~OPEN_FIGURES
    close(gcf)
  endif
endif
