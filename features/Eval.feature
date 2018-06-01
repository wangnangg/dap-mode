Feature: Running without debug

  Background:
    Given I have maven project "m" in "tmp"
    And I add project "m" folder "tmp" to the list of workspace folders
    And I have a java file "tmp/m/src/main/java/temp/App.java"
    And I clear the buffer
    And I insert:
    """
    package temp;

    class App {
    public static void main(String[] args) {
    String toEvaluate = "Evaluated";
    System.out.print(toEvaluate);
    }

    }
    """
    And I call "save-buffer"
    And I start lsp-java
    And The server status must become "LSP::Started"

  @WIP
  Scenario: Eval successfull
    When I place the cursor before "System"
    And I call "dap-toggle-breakpoint"
    And I go to beginning of buffer
    And I attach handler "breakpoint" to hook "dap-stopped-hook"
    And I call "dap-java-debug"
    Then The hook handler "breakpoint" would be called
    And the cursor should be before "System"
    And I start an action chain
    When I press "M-x"
    When I type "dap-eval"
    And I press "<return>"
    When I type "toEvaluate"
    And I press "<return>"
    And I execute the action chain

    # And I call "dap-continue"
    And I should see buffer "*out*" with content "123"


    # And I insert "i\n"
    # And I press
    Then I should see message "Evaluated"
