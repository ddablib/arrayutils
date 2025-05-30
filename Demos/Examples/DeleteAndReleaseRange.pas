{
 * Example code for TArrayUtils.DeleteAndReleaseRange<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit DeleteAndReleaseRange;

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

procedure DeleteAndReleaseRange_Eg1;
var
  R, R0, R1, R2, R3, R4: TMockResource;
  RA, Expected: TArray<TMockResource>;
begin
  // create array of 5 "resources"
  R0 := TMockResource.Create(0);
  R1 := TMockResource.Create(1);
  R2 := TMockResource.Create(2);
  R3 := TMockResource.Create(3);
  R4 := TMockResource.Create(4);
  RA := TArray<TMockResource>.Create(R0, R1, R2, R3, R4);
  Assert(Length(RA) = 5, '5 element array expected');
  Assert(TMockResource.InstanceCount = 5, 'Expected 5 "resources" allocated');

  // delete and release elements in range 1..3
  TArrayUtils.DeleteAndReleaseRange<TMockResource>(
    RA,
    1,
    3,
    procedure (const AElem: TMockResource) begin AElem.Release end
  );
  // check array size reduced and one resource released
  Assert(Length(RA) = 2, '2 element array expected following deletion');
  Assert(TMockResource.InstanceCount = 2, 'Expected 2 "resources" allocated');
  Expected := TArray<TMockResource>.Create(R0, R4);
  Assert(TArrayUtils.Equal<TMockResource>(Expected, RA),
    'updated array content not as expected');

  // clear up remaining allocations
  for R in RA do R.Release;
  Assert(TMockResource.InstanceCount = 0, 'Expected all "resources" released');
end;

procedure DeleteAndReleaseRange_Eg2;
var
  R, R0, R1, R2, R3, R4: TMockResource;
  RA, Expected: TArray<TMockResource>;
begin
  // create array of 5 "resources"
  R0 := TMockResource.Create(0);
  R1 := TMockResource.Create(1);
  R2 := TMockResource.Create(2);
  R3 := TMockResource.Create(3);
  R4 := TMockResource.Create(4);
  RA := TArray<TMockResource>.Create(R0, R1, R2, R3, R4);
  Assert(Length(RA) = 5, '5 element array expected');
  Assert(TMockResource.InstanceCount = 5, 'Expected 5 "resources" allocated');

  // delete and release elements @ indices 2..end of array
  TArrayUtils.DeleteAndReleaseRange<TMockResource>(
    RA,
    2,
    procedure (const AElem: TMockResource) begin AElem.Release end
  );
  // check array size reduced and three resources released
  Assert(Length(RA) = 2, '2 element array expected following deletion');
  Assert(TMockResource.InstanceCount = 2, 'Expected 2 "resources" allocated');
  Expected := TArray<TMockResource>.Create(R0, R1);
  Assert(TArrayUtils.Equal<TMockResource>(Expected, RA),
    'updated array content not as expected');

  // clear up remaining allocations
  for R in RA do R.Release;
  Assert(TMockResource.InstanceCount = 0, 'Expected all "resources" released');
end;

initialization

TRegistrar.Add(
  'DeleteAndReleaseRange<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('DeleteAndReleaseRange_Eg1', @DeleteAndReleaseRange_Eg1),
    TProcedureInfo.Create('DeleteAndReleaseRange_Eg2', @DeleteAndReleaseRange_Eg2)
  )
);

end.
