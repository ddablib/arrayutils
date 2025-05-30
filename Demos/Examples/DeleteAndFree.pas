{
 * Example code for TArrayUtils.DeleteAndFree<T:class>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit DeleteAndFree;

interface

implementation

uses
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

type
  TObjectEx = class
  public
    var ID: Char;
    class var InstanceCount: Integer;
    constructor Create(AID: Char);
    destructor Destroy; override;
  end;

{ TObjectEx }

constructor TObjectEx.Create(AID: Char);
begin
  inherited Create;
  ID := AID;
  Inc(InstanceCount);
end;

destructor TObjectEx.Destroy;
begin
  Dec(InstanceCount);
  inherited;
end;

procedure DeleteAndFree_Eg1;
var
  A: TArray<TObjectEx>;
  Obj: TObjectEx;
begin
  // Start with no objects
  Assert(TObjectEx.InstanceCount = 0, 'TObjectEx <> 0 instances');
  // Create array of 3 objects
  A := TArray<TObjectEx>.Create(
    TObjectEx.Create('A'), TObjectEx.Create('B'), TObjectEx.Create('C')
  );
  Assert(Length(A) = 3, 'Array length <> 3');
  Assert(TObjectEx.InstanceCount = 3, 'TObjectEx <> 3 instances');
  Assert(A[1].ID = 'B', 'A[1] <> B');

  // Delete object @ index 1: this will remove it from the array and free it
  TArrayUtils.DeleteAndFree<TObjectEx>(A, 1);
  Assert(Length(A) = 2, 'Array length <> 2');
  Assert(TObjectEx.InstanceCount = 2, 'TObjectEx <> 2 instances');
  Assert(A[1].ID <> 'B', 'Last object ID = B');
  // Tidy up remaining 2 objects
  for Obj in A do
    Obj.Free;
  Assert(TObjectEx.InstanceCount = 0, 'TObjectEx <> 0 instances');
end;

procedure DeleteAndFree_Eg2;
var
  A: TArray<TObjectEx>;
  Obj: TObjectEx;
  Constraint: TArrayUtils.TConstraint<TObjectEx>;
begin
  // Start with no objects
  Assert(TObjectEx.InstanceCount = 0, 'TObjectEx <> 0 instances');

  // Create array of 4 objects
  A := TArray<TObjectEx>.Create(
    TObjectEx.Create('A'), TObjectEx.Create('B'),
    TObjectEx.Create('C'), TObjectEx.Create('D')
  );
  Assert(Length(A) = 4, 'Array length <> 4');
  Assert(TObjectEx.InstanceCount = 4, 'TObjectEx <> 4 instances');
  Assert(A[1].ID = 'B', 'A[1] <> B');
  Assert(A[2].ID = 'C', 'A[2] <> C');

  // Delete objects @ index 1 & 2 with IDs 'B' and 'C':
  // this will remove the objects from the array and free them
  TArrayUtils.DeleteAndFree<TObjectEx>(A, [1, 2]);
  Assert(Length(A) = 2, 'Array length <> 2');
  Assert(TObjectEx.InstanceCount = 2, 'TObjectEx <> 2 instances');
  Constraint := function (const AElem: TObjectEx): Boolean
    begin
      Result := (AElem.ID = 'B') or (AElem.ID = 'C');
    end;
  Assert(
    not TArrayUtils.Some<TObjectEx>(A, Constraint),
    'B or C found in array'
  );

  // Tidy up remaining 2 objects
  for Obj in A do
    Obj.Free;
  Assert(TObjectEx.InstanceCount = 0, 'TObjectEx <> 0 instances');
end;

initialization

TRegistrar.Add(
  'DeleteAndFree<T: class>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('DeleteAndFree_Eg1', @DeleteAndFree_Eg1),
    TProcedureInfo.Create('DeleteAndFree_Eg2', @DeleteAndFree_Eg2)
  )
);

end.
