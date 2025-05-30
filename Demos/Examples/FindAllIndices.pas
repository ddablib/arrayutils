{
 * Example code for TArrayUtils.FindAllIndices<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit FindAllIndices;

interface

implementation

uses
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure FindAllIndices_Eg1;
var
  A, B, Got, Expected: TArray<Integer>;
  Constraint: TArrayUtils.TConstraint<Integer>;
begin
  Constraint := function (const AElem: Integer): Boolean
    begin
      Result := AElem >= 4;
    end;

  A := TArray<Integer>.Create(1, 2, 3, 4, 5, 3);
  Got := TArrayUtils.FindAllIndices<Integer>(A, Constraint);
  Expected := TArray<Integer>.Create(3, 4);
  Assert(TArrayUtils.Equal<Integer>(Expected, Got));

  B := TArray<Integer>.Create(1, 2, 3);
  Got := TArrayUtils.FindAllIndices<Integer>(B, Constraint);
  Expected := TArray<Integer>.Create();
  Assert(TArrayUtils.Equal<Integer>(Expected, Got));
end;

procedure FindAllIndices_Eg2;
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
  Got := TArrayUtils.FindAllIndices<Integer>(A, IsLocalMaxElem);
  Expected := TArray<Integer>.Create(2, 5);
  Assert(TArrayUtils.Equal<Integer>(Expected, Got));

  B := TArray<Integer>.Create(1, 1, 1, 1);
  Got := TArrayUtils.FindAllIndices<Integer>(B, IsLocalMaxElem);
  Expected := TArray<Integer>.Create();
  Assert(TArrayUtils.Equal<Integer>(Expected, Got));
end;

initialization

TRegistrar.Add(
  'FindAllIndices<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('FindAllIndices_Eg1', @FindAllIndices_Eg1),
    TProcedureInfo.Create('FindAllIndices_Eg1', @FindAllIndices_Eg2)
  )
);

end.
