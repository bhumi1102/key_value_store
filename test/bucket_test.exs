defmodule KVStore.BucketTest do
  use ExUnit.Case, async: true

  test "stores values by key" do
    {:ok, bucket} = KVStore.Bucket.start_link
    assert KVStore.Bucket.get(bucket, "milk") == nil

    KVStore.Bucket.put(bucket, "milk", 3)
    assert KVStore.Bucket.get(bucket, "milk") == 3
  end
end