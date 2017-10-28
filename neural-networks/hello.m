printf("Hello\n");
if (! exist ("arg_list", "var"))
  arg_list = argv ();
  for i = 5:nargin
    printf (" %s", arg_list{i});
  end
endif
