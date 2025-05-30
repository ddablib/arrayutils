{
 * Example code for TArrayUtils.DeleteAndFreeRange<T:class>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit DeleteAndFreeRange;

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

procedure DeleteAndFreeRange_Eg1;
var
  A: TArray<TObjectEx>;
  Obj: TObjectEx;
  Constraint: TArrayUtils.TConstraint<TObjectEx>;
begin
  // Start with no objects
  Assert(TObjectEx.InstanceCount = 0, 'TObjectEx <> 0 instances');

  // Create array of 6 objects
  A := TArray<TObjectEx>.Create(
    TObjectEx.Create('A'), TObjectEx.Create('B'),
    TObjectEx.Create('C'), TObjectEx.Create('D'),
    TObjectEx.Create('E'), TObjectEx.Create('F')
  );
  Assert(Length(A) = 6, 'Array length <> 6');
  Assert(TObjectEx.InstanceCount = 6, 'TObjectEx <> 4 instances');
  Assert(A[2].ID = 'C', 'A[2] <> C');
  Assert(A[3].ID = 'D', 'A[3] <> D');
  Assert(A[4].ID = 'E', 'A[4] <> E');

  // Delete and free all objects in range [2..4]
  TArrayUtils.DeleteAndFreeRange<TObjectEx>(A, 2, 4);
  Assert(Length(A) = 3, 'Array length <> 3');
  Assert(TObjectEx.InstanceCount = 3, 'TObjectEx <> 3 instances');
  Constraint := function (const AElem: TObjectEx): Boolean
    begin
      Result := (AElem.ID = 'C') or (AElem.ID = 'D') or (AElem.ID = 'E');
    end;
  Assert(
    not TArrayUtils.Some<TObjectEx>(A, Constraint),
    'C, D, or E found in array'
  );

  // Tidy up remaining objects
  for Obj in A do
    Obj.Free;
  Assert(TObjectEx.InstanceCount = 0, 'TObjectEx <> 0 instances');
end;

procedure DeleteAndFreeRange_Eg2;
var
  A: TArray<TObjectEx>;
  Obj: TObjectEx;
  Constraint: TArrayUtils.TConstraint<TObjectEx>;
begin
  // Start with no objects
  Assert(TObjectEx.InstanceCount = 0, 'TObjectEx <> 0 instances');

  // Create array of 6 objects
  A := TArray<TObjectEx>.Create(
    TObjectEx.Create('A'), TObjectEx.Create('B'),
    TObjectEx.Create('C'), TObjectEx.Create('D'),
    TObjectEx.Create('E'), TObjectEx.Create('F')
  );
  Assert(Length(A) = 6, 'Array length <> 6');
  Assert(TObjectEx.InstanceCount = 6, 'TObjectEx <> 4 instances');
  Assert(A[2].ID = 'C', 'A[2] <> C');
  Assert(A[3].ID = 'D', 'A[3] <> D');
  Assert(A[4].ID = 'E', 'A[4] <> E');
  Assert(A[5].ID = 'F', 'A[4] <> F');

  // Delete and free all objects from index 2 to the end of the array
  TArrayUtils.DeleteAndFreeRange<TObjectEx>(A, 2);
  Assert(Length(A) = 2, 'Array length <> 2');
  Assert(TObjectEx.InstanceCount = 2, 'TObjectEx <> 2 instances');
  Constraint := function (const AElem: TObjectEx): Boolean
    begin
      Result := (AElem.ID = 'C') or (AElem.ID = 'D')
        or (AElem.ID = 'E') or (AElem.ID = 'F');
    end;
  Assert(
    not TArrayUtils.Some<TObjectEx>(A, Constraint),
    'C, D, E or F found in array'
  );

  // Tidy up remaining objects
  for Obj in A do
    Obj.Free;
  Assert(TObjectEx.InstanceCount = 0, 'TObjectEx <> 0 instances');
end;

initialization

TRegistrar.Add(
  'DeleteAndFreeRange<T: class>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('DeleteAndFreeRange_Eg1', @DeleteAndFreeRange_Eg1),
    TProcedureInfo.Create('DeleteAndFreeRange_Eg2', @DeleteAndFreeRange_Eg2)
  )
);

end.
