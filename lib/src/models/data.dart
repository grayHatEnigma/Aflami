// This class is interface to the ui to view the response data from the api

class Data<T> {
  Status status;
  T data;
  String message;

  // diffrent constructors  to match the state
  Data.loading(this.message) : status = Status.LOADING;
  Data.completed(this.data) : status = Status.COMPLETED;
  Data.error(this.message) : status = Status.ERROR;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}

enum Status { LOADING, COMPLETED, ERROR }
