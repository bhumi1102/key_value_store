defmodule KVStore.RegistryTest do
  use ExUnit.Case, async: true

  setup context do
    {:ok, registry} = KVStore.Registry.start_link(context.test)
    {:ok, registry: registry}
  end

  test "spawns buckets", %{registry: registry} do
    assert KVStore.Registry.lookup(registry, "shopping") == :error

    KVStore.Registry.create(registry, "shopping")
    assert {:ok, bucket} = KVStore.Registry.lookup(registry, "shopping")

    KVStore.Bucket.put(bucket, "milk", 1)
    assert KVStore.Bucket.get(bucket, "milk") == 1
  end

  ## the registry process needs to monitor the state of the bucket processes
  test "removes buckets on exit", %{registry: registry} do
    KVStore.Registry.create(registry, "shopping")
    {:ok, bucket} = KVStore.Registry.lookup(registry, "shopping")
    Agent.stop(bucket)
    assert KVStore.Registry.lookup(registry, "shopping") == :error
  end

end

