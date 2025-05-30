{
 * Example code for TArrayUtils.PopAndFree<T:class>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit PopAndFree;

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

procedure PopAndFree_Eg;
var
  A: TArray<TObjectEx>;
  Obj, ShiftedObj: TObjectEx;
begin
  // Start with no objects
  Assert(TObjectEx.InstanceCount = 0, 'TObjectEx <> 0 instances');

  // Create array of 3 objects using Push<T>
  SetLength(A, 0);
  TArrayUtils.Push<TObjectEx>(A, TObjectEx.Create('C'));
  TArrayUtils.Push<TObjectEx>(A, TObjectEx.Create('B'));
  TArrayUtils.Push<TObjectEx>(A, TObjectEx.Create('A'));
  Assert(Length(A) = 3, 'Array length <> 3');
  Assert(TObjectEx.InstanceCount = 3, 'TObjectEx <> 3 instances');
  Assert(TArrayUtils.Last<TObjectEx>(A).ID = 'A', 'Last object ID <> A');

  // Pop last object with PopAndFree<T:class>:
  // this will remove it from the array and free it
  TArrayUtils.PopAndFree<TObjectEx>(A);
  // check object was removed from array
  Assert(Length(A) = 2, 'Array length <> 2');
  // check removed object was freed
  Assert(TObjectEx.InstanceCount = 2, 'TObjectEx <> 2 instances');
  Assert(TArrayUtils.Last<TObjectEx>(A).ID = 'B', 'Last object ID <> B');

  // Pop new last object with Pop<T>:
  // this will remove it from the array but not free it
  ShiftedObj := TArrayUtils.Pop<TObjectEx>(A);
  // check object removed from array
  Assert(Length(A) = 1, 'Array length <> 1');
  // check removed object was not freed
  Assert(TObjectEx.InstanceCount = 2, 'TObjectEx <> 2 instances');
  Assert(TArrayUtils.Last<TObjectEx>(A).ID = 'C', 'Last object ID <> C');

  // Tidy up remaining un-freed objects
  ShiftedObj.Free;
  for Obj in A do
    Obj.Free;
  Assert(TObjectEx.InstanceCount = 0, 'TObjectEx <> 0 instances');
end;

initialization

TRegistrar.Add(
  'PopAndFree<T: class>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('PopAndFree_Eg', @PopAndFree_Eg)
  )
);

end.
