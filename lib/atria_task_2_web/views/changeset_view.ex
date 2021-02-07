defmodule AtriaTask2Web.ChangesetView do
  use AtriaTask2Web, :view

  def translate_errors(changeset) do
    %{errors: Ecto.Changeset.traverse_errors(changeset, &translate_error/1), status: false}
  end

  def translate_ok(changeset, "User") do
    %{message: "#{changeset.full_name} user signed up successfully", status: true}
  end

  def translate_ok(changeset, "Admin") do
    %{message: "#{changeset.full_name} admin signed up successfully", status: true}
  end

  def translate_ok(changeset, "Event") do
    %{message: "#{changeset.name} event created successfully", status: true}
  end

  def translate_ok(changeset, "Event Update") do
    %{message: "#{changeset.name} event updated successfully", status: true}
  end

  def translate_ok(changeset, "Event Delete") do
    %{message: "#{changeset.name} event deleted successfully", status: true}
  end

  def render("error.json", %{changeset: changeset}) do
    # When encoded, the changeset returns its errors
    # as a JSON object. So we just pass it forward.
    %{errors: translate_errors(changeset)}
  end
end
