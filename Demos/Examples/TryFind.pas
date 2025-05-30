{
 * Example code for TArrayUtils.TryFind<T>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit TryFind;

interface

implementation

uses
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure TryFind_Eg1;
var
  A, B: TArray<Integer>;
  Found: Integer;
  Constraint: TArrayUtils.TConstraint<Integer>;
begin
  A := TArray<Integer>.Create(1, 2, 3, 4, 5, 3);
  B := TArray<Integer>.Create(1, 2, 3);
  Constraint := function (const AElem: Integer): Boolean
    begin
      Result := AElem >= 4;
    end;
  Assert(TArrayUtils.TryFind<Integer>(A, Constraint, Found) = True);
  Assert(Found = 4);
  Assert(TArrayUtils.TryFind<Integer>(B, Constraint, Found) = False);
  // `Found` is undefined
end;

procedure TryFind_Eg2;
var
  IsLocalMaxElem: TArrayUtils.TConstraintEx<Integer>;
  A, B: TArray<Integer>;
  Found: Integer;
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
  Assert(TArrayUtils.TryFind<Integer>(A, IsLocalMaxElem, Found) = True);
  Assert(Found = 3);

  B := TArray<Integer>.Create(1, 1, 1, 1);
  Assert(TArrayUtils.TryFind<Integer>(B, IsLocalMaxElem, Found) = False);
  // Found is not defined
end;

initialization

TRegistrar.Add(
  'TryFind<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('TryFind_Eg1', @TryFind_Eg1),
    TProcedureInfo.Create('TryFind_Eg2', @TryFind_Eg2)
  )
);

end.
