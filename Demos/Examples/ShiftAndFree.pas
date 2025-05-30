{
 * Example code for TArrayUtils.ShiftAndFree<T:class>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit ShiftAndFree;

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

procedure ShiftAndFree_Eg;
var
  A: TArray<TObjectEx>;
  Obj, ShiftedObj: TObjectEx;
begin
  // Start with no objects
  Assert(TObjectEx.InstanceCount = 0, 'TObjectEx <> 0 instances');

  // Create array of 3 objects using UnShift<T>
  SetLength(A, 0);
  TArrayUtils.UnShift<TObjectEx>(A, TObjectEx.Create('C'));
  TArrayUtils.UnShift<TObjectEx>(A, TObjectEx.Create('B'));
  TArrayUtils.UnShift<TObjectEx>(A, TObjectEx.Create('A'));
  Assert(Length(A) = 3, 'Array length <> 3');
  Assert(TObjectEx.InstanceCount = 3, 'TObjectEx <> 3 instances');
  Assert(TArrayUtils.First<TObjectEx>(A).ID = 'A', 'First object ID <> A');

  // Pop first object with ShiftAndFree<T:class>:
  // this will remove it from the array and free it
  TArrayUtils.ShiftAndFree<TObjectEx>(A);
  // check object was removed from array
  Assert(Length(A) = 2, 'Array length <> 2');
  // check removed object was freed
  Assert(TObjectEx.InstanceCount = 2, 'TObjectEx <> 2 instances');
  Assert(TArrayUtils.First<TObjectEx>(A).ID = 'B', 'First object ID <> B');

  // Pop new first object with Shift<T>:
  // this will remove it from the array but not free it
  ShiftedObj := TArrayUtils.Shift<TObjectEx>(A);
  // check object removed from array
  Assert(Length(A) = 1, 'Array length <> 1');
  // check removed object was not freed
  Assert(TObjectEx.InstanceCount = 2, 'TObjectEx <> 2 instances');
  Assert(TArrayUtils.First<TObjectEx>(A).ID = 'C', 'First object ID <> C');

  // Tidy up remaining un-freed objects
  ShiftedObj.Free;
  for Obj in A do
    Obj.Free;
  Assert(TObjectEx.InstanceCount = 0, 'TObjectEx <> 0 instances');
end;

initialization

TRegistrar.Add(
  'ShiftAndFree<T: class>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('ShiftAndFree_Eg', @ShiftAndFree_Eg)
  )
);

end.
