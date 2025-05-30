{
 * Example code for TArrayUtils.Reduce<T> & TArrayUtils.Reduce<TIn,TOut>.
 *
 * Contains copies the example code included in the Array Utilities Unit
 * documentation at https://delphidabbler.com/url/arrayutils-docs.
 *
 * Any copyright in this file is dedicated to the Public Domain.
 * http://creativecommons.org/publicdomain/zero/1.0/
}

unit Reduce;

interface

implementation

uses
  Math,
  DelphiDabbler.Lib.ArrayUtils,
  Registrar;

procedure Reduce_SingleType_Eg1;
var
  A: TArray<Integer>;
  SumCallback: TArrayUtils.TReducer<Integer>;
begin
  SumCallback := function (const AAccumulator, ACurrent: Integer): Integer
    begin
      Result := ACurrent + AAccumulator;
    end;
  A := TArray<Integer>.Create(1, 3, 5, 7, 9);
  Assert(TArrayUtils.Reduce<Integer>(A, SumCallback) = 25);
end;

procedure Reduce_SingleType_Eg2;
var
  A, B: TArray<Integer>;
  SumCallback: TArrayUtils.TReducer<Integer>;
  RunningTotal: Integer;
begin
  SumCallback := function (const AAccumulator, ACurrent: Integer): Integer
    begin
      Result := ACurrent + AAccumulator;
    end;
  A := TArray<Integer>.Create(1, 3, 5, 7, 9);   // sum = 25
  B := TArray<Integer>.Create(2, 4, 6, 8, 10);  // sum = 30
  RunningTotal := 0;
  RunningTotal := TArrayUtils.Reduce<Integer>(A, SumCallback, RunningTotal);
  Assert(RunningTotal = 25);
  RunningTotal := TArrayUtils.Reduce<Integer>(B, SumCallback, RunningTotal);
  Assert(RunningTotal = 55);
end;

procedure Reduce_SingleType_Eg3;
var
  SumDistancesReducer: TArrayUtils.TReducerEx<Integer>;
  A: TArray<Integer>;
begin
  // Adds the absolute distances between adjacent elements of an integer array
  SumDistancesReducer := function (const AAccumulator, ACurrent: Integer;
    const AIndex: Integer; const AArray: array of Integer): Integer
    var
      Distance: Integer;
    begin
      Result := AAccumulator;
      if AIndex = 0 then
        Exit;
      Distance := Abs(AArray[AIndex] - AArray[AIndex - 1]);
      Result := Result + Distance;
    end;

  A := TArray<Integer>.Create(3, 6, 3, 8, 3, 2);
  Assert(TArrayUtils.Reduce<Integer>(A, SumDistancesReducer, 0) = 17);
end;

procedure Reduce_TwoTypes_Eg1;
const
  RequiredStr = 'needle';
var
  A: TArray<string>;
  CountStrsReducer: TArrayUtils.TReducer<string,Integer>;
begin
  CountStrsReducer := function (const AAccumulator: Integer;
    const ACurrent: string): Integer
    begin
      Result := AAccumulator;
      if Pos(RequiredStr, ACurrent) = 1 then
        Inc(Result);
    end;
  A := TArray<string>.Create('find', 'the', 'needle', 'and', 'more', 'needles');
  Assert(TArrayUtils.Reduce<string,Integer>(A, CountStrsReducer, 0) = 2);
end;

procedure Reduce_TwoTypes_Eg2;
var
  AverageReducer: TArrayUtils.TReducerEx<Integer,Extended>;
  A: TArray<Integer>;
begin
  AverageReducer := function (const AAccumulator: Extended;
    const ACurrent: Integer; const AIndex: Integer;
    const AArray: array of Integer): Extended
    begin
      // Don't call with empty array
      Result := AAccumulator + ACurrent / Length(A);
    end;
  A := TArray<Integer>.Create(3, 6, 3, 8, 3, 2);
  Assert(
    SameValue(
      4.16666666666667,
      TArrayUtils.Reduce<Integer,Extended>(A, AverageReducer, 0),
      0.000001
    )
  );
end;

initialization

TRegistrar.Add(
  'Reduce<T>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('Reduce_SingleType_Eg1', @Reduce_SingleType_Eg1),
    TProcedureInfo.Create('Reduce_SingleType_Eg2', @Reduce_SingleType_Eg2),
    TProcedureInfo.Create('Reduce_SingleType_Eg3', @Reduce_SingleType_Eg3)
  )
);

TRegistrar.Add(
  'Reduce<TIn,TOut>',
  TArray<TProcedureInfo>.Create(
    TProcedureInfo.Create('Reduce_TwoTypes_Eg1', @Reduce_TwoTypes_Eg1),
    TProcedureInfo.Create('Reduce_TwoTypes_Eg2', @Reduce_TwoTypes_Eg2)
  )
);

end.
