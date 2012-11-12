{$i xpc.inc}
program run_tests;
  uses cw, xpc, sysutils {$i run-tests.use }; // includes test_*.pas

  type
    outcome = ( pass, fail, err );
    testcase = procedure;
  var
    overall : outcome;
    passed, failed, broken  : integer;

  procedure setup;
  begin
    writeln( 'running tests' );
  end;

  procedure run( to_test : testcase );
    var result : outcome = pass;
  begin
    // chk.reset;
    try to_test except
      on Exception do result := err
    end;
    case result of
      pass : begin inc( passed ); cwrite( '|go' ) end;
      fail : begin inc( failed ); cwrite( '|y!' ) end;
      err  : begin inc( broken ); cwrite( '|rx' ) end;
    end;
  end;

  procedure report;
    var total : integer;
  begin
    cwriteln( '|K ');
    writeln;
    cwriteln('----------------------------------------------|w' );
    writeln;
    total := passed + failed + broken;
    writeln( total, ' tests run.' );
    writeln( passed, ' tests passed; ',
             failed, ' failed; ',
             broken, ' broken.' );
  end;

begin
  setup;
  {$i run-tests.run }
  report;
end.
