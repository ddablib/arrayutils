{
 * Example code for TArrayUtils.ShiftAndRelease<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit ShiftAndRelease;

interface

implementation

uses
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

type
  TMockResource = record
  public
    constructor Create(const AField: Integer);
    procedure Release;
    var Field: Integer;
    class var InstanceCount: Cardinal;
  end;

{ TMockResource }

constructor TMockResource.Create(const AField: Integer);
begin
  Field := AField;
  Inc(InstanceCount);
end;

procedure TMockResource.Release;
begin
  Dec(InstanceCount);
end;

procedure ShiftAndRelease_Eg;
var
  R, R0, R1, R2: TMockResource;
  RA, Expected: TArray<TMockResource>;
begin
  // create array of 3 "resources"
  R0 := TMockResource.Create(0);
  R1 := TMockResource.Create(1);
  R2 := TMockResource.Create(2);
  RA := TArray<TMockResource>.Create(R0, R1, R2);
  Assert(Length(RA) = 3, '3 element array expected');
  Assert(TMockResource.InstanceCount = 3, 'Expected 3 "resources" allocated');
  Assert(TArrayUtils.First<TMockResource>(RA).Field = 0, '0 1st elem expected');

  // pop and release element at end of array
  TArrayUtils.ShiftAndRelease<TMockResource>(
    RA,
    procedure (const AElem: TMockResource) begin AElem.Release end
  );

  // check array after popping
  Assert(TArrayUtils.First<TMockResource>(RA).Field = 1, '1 1st elem expected');
  Assert(Length(RA) = 2, '2 element array expected following deletion');
  Assert(TMockResource.InstanceCount = 2, 'Expected 2 "resources" allocated');
  Expected := TArray<TMockResource>.Create(R1, R2);
  Assert(TArrayUtils.Equal<TMockResource>(Expected, RA),
    'updated array content not as expected');

  // clear up remaining allocations
  for R in RA do R.Release;
  Assert(TMockResource.InstanceCount = 0, 'Expected all "resources" released');
end;

initialization

TRegistrar.Add(
  'ShiftAndRelease<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('ShiftAndRelease_Eg', @ShiftAndRelease_Eg)
  )
);

end.
