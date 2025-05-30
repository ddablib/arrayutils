{
 * Example code for TArrayUtils.DeleteAndRelease<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit DeleteAndRelease;

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

procedure DeleteAndRelease_Eg1;
var
  R, R0, R1, R2, R3: TMockResource;
  RA, Expected: TArray<TMockResource>;
begin
  // create array of 4 "resources"
  R0 := TMockResource.Create(0);
  R1 := TMockResource.Create(1);
  R2 := TMockResource.Create(2);
  R3 := TMockResource.Create(3);
  RA := TArray<TMockResource>.Create(R0, R1, R2, R3);
  Assert(Length(RA) = 4, '4 element array expected');
  Assert(TMockResource.InstanceCount = 4, 'Expected 4 "resources" allocated');

  // delete and release element @ index 2
  TArrayUtils.DeleteAndRelease<TMockResource>(
    RA,
    2,
    procedure (const AElem: TMockResource) begin AElem.Release end
  );
  // check array size reduced and one resource released
  Assert(Length(RA) = 3, '3 element array expected following deletion');
  Assert(TMockResource.InstanceCount = 3, 'Expected 3 "resources" allocated');
  Expected := TArray<TMockResource>.Create(R0, R1, R3);
  Assert(TArrayUtils.Equal<TMockResource>(Expected, RA),
    'updated array content not as expected');

  // clear up remaining allocations
  for R in RA do R.Release;
  Assert(TMockResource.InstanceCount = 0, 'Expected all "resources" released');
end;

procedure DeleteAndRelease_Eg2;
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

  // delete and release elements @ indices 0, 2, 3
  TArrayUtils.DeleteAndRelease<TMockResource>(
    RA,
    [2, 3, 0],
    procedure (const AElem: TMockResource) begin AElem.Release end
  );
  // check array size reduced and three resources released
  Assert(Length(RA) = 2, '2 element array expected following deletion');
  Assert(TMockResource.InstanceCount = 2, 'Expected 2 "resources" allocated');
  Expected := TArray<TMockResource>.Create(R1, R4);
  Assert(TArrayUtils.Equal<TMockResource>(Expected, RA),
    'updated array content not as expected');

  // clear up remaining allocations
  for R in RA do R.Release;
  Assert(TMockResource.InstanceCount = 0, 'Expected all "resources" released');
end;

initialization

TRegistrar.Add(
  'DeleteAndRelease<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('DeleteAndRelease_Eg1', @DeleteAndRelease_Eg1),
    TProcedureInfo.Create('DeleteAndRelease_Eg2', @DeleteAndRelease_Eg2)
  )
);

end.
