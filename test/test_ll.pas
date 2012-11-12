{$i test_ll.def }
implementation uses ll, sysutils;

  var nodes : list;

  procedure test_init;
  begin
    nodes := ll.list.init;
    // raise Exception.create( 'oh no!' );
  end;

end.
