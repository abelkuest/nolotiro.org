# frozen_string_literal: true

module Yahoo
  #
  # Wrapper around a set of Yahoo YQL woeids
  #
  class ResultSet
    def initialize(result_set)
      @result_set = result_set
    end

    def as_options
      locations.map do |location|
        woeid = location.woeid
        count = I18n.t('nlt.ads.count', count: ad_counts[woeid])
        label = "#{location.fullname} (#{count})"

        [label, woeid]
      end
    end

    def count
      locations.size
    end

    private

    def locations
      @locations ||= @result_set.map { |result| Location.new(result) }
    end

    def woeids
      @woeids ||= locations.map(&:woeid)
    end

    def ad_counts
      @ad_counts ||= null_ad_counts.merge(non_null_ad_counts)
    end

    def null_ad_counts
      woeids.zip([0] * woeids.size).to_h
    end

    def non_null_ad_counts
      Ad.give.where(woeid_code: woeids).group(:woeid_code).size
    end
  end
end
