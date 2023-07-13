class Hooks
  def initialize(hooks)
    @hooks = hooks
  end

  def before_restore
    return unless @hooks.respond_to?(:before_restore)

    @hooks.before_restore
  end

  def after_restore
    return unless @hooks.respond_to?(:after_restore)

    @hooks.after_restore
  end

  def before_dump
    return unless @hooks.respond_to?(:before_dump)

    @hooks.before_dump
  end

  def after_dump
    return unless @hooks.respond_to?(:after_dump)

    @hooks.after_dump
  end
end
