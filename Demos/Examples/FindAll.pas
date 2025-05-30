{
 * Example code for TArrayUtils.FindAll<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit FindAll;

interface

implementation

uses
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure FindAll_Eg1;
var
  A, B, Got, Expected: TArray<Integer>;
  Constraint: TArrayUtils.TConstraint<Integer>;
begin
  A := TArray<Integer>.Create(1, 2, 3, 4, 5, 3);
  B := TArray<Integer>.Create(1, 2, 3);
  Constraint := function (const AElem: Integer): Boolean
    begin
      Result := AElem >= 4;
    end;
  Got := TArrayUtils.FindAll<Integer>(A, Constraint);
  Expected := TArray<Integer>.Create(4, 5);
  Assert(TArrayUtils.Equal<Integer>(Expected, Got)); // using default comparer
  Got := TArrayUtils.FindAll<Integer>(B, Constraint);
  Assert(Length(Got) = 0);  // nothing found
end;

procedure FindAll_Eg2;
var
  IsLocalMaxElem: TArrayUtils.TConstraintEx<Integer>;
  A, B, Got, Expected: TArray<Integer>;
begin
  IsLocalMaxElem :=
    function (const AElem: Integer; const AIndex: Integer;
      const A: array of Integer): Boolean
    begin
      if Length(A) = 0 then
        // no local maxima in an empty array
        Exit(False);
      if Length(A) = 1 then
        // the only element in a 1 element array is considered to be a maximum
        Exit(True);
      // Length(A) >= 2
      if (AIndex = 0) then
        // 1st elem: peak if next elem smaller
        Result := A[Succ(AIndex)] < AElem
      else if AIndex = Pred(Length(A)) then
        // last elem: peak if previous elem smaller
        Result := A[Pred(AIndex)] < AElem
      else
        // not 1st or last: peak if > than elems on either side
        Result := (A[Succ(AIndex)] < AElem) and (A[Pred(AIndex)] < AElem);
    end;

  A := TArray<Integer>.Create(1, 2, 3, 2, 3, 5, 1);
  Got := TArrayUtils.FindAll<Integer>(A, IsLocalMaxElem);
  Expected := TArray<Integer>.Create(3, 5);
  Assert(TArrayUtils.Equal<Integer>(Expected, Got));

  B := TArray<Integer>.Create(1, 1, 1, 1);
  Got := TArrayUtils.FindAll<Integer>(B, IsLocalMaxElem);
  Expected := TArray<Integer>.Create();
  Assert(TArrayUtils.Equal<Integer>(Expected, Got));
end;

initialization

TRegistrar.Add(
  'FindAll<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('FindAll_Eg1', @FindAll_Eg1),
    TProcedureInfo.Create('FindAll_Eg1', @FindAll_Eg2)
  )
);

end.
