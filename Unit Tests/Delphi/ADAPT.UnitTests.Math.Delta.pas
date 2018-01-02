unit ADAPT.UnitTests.Math.Delta;

interface

{$I ADAPT.inc}

uses
  {$IFDEF ADAPT_USE_EXPLICIT_UNIT_NAMES}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF ADAPT_USE_EXPLICIT_UNIT_NAMES}
  DUnitX.TestFramework,
  ADAPT.Intf, ADAPT.Math.Delta.Intf;

type
  [TestFixture]
  TADUTMathDelta = class(TObject)
  public
    [Test]
    procedure BasicIntegrity;
  end;

implementation

uses
  ADAPT, ADAPT.Math.Delta;

type
  // Interfaces
  IADFloatDelta = IADDeltaValue<ADFloat>;
  // Classes
  TADFloatDelta = TADDeltaValue<ADFloat>;

{ TADUTMathDelta }

procedure TADUTMathDelta.BasicIntegrity;
var
  LDelta: IADFloatDelta;
  LCurrentTime: ADFloat;
begin
  // Get the current time as of Test Start.
  LCurrentTime := ADReferenceTime;
  // Create an empty Delta Value
  LDelta := TADFloatDelta.Create;

  // Set the Value for test start to 1.00
  LDelta.ValueAt[LCurrentTime] := 1.00;

  // Set the Value for Start Time + 1 second to 2.00
  LDelta.ValueAt[LCurrentTime + 1] := 2.00;

  // Verify the current exact values
  Assert.IsTrue(LDelta.ValueAt[LCurrentTime] = 1.00, Format('Value at %n should be 1.00 but instead got %n', [LCurrentTime, LDelta.ValueAt[LCurrentTime]]));
  Assert.IsTrue(LDelta.ValueAt[LCurrentTime + 1] = 2.00, Format('Value at %n should be 2.00 but instead got %n', [LCurrentTime + 1, LDelta.ValueAt[LCurrentTime + 1]]));
end;

end.