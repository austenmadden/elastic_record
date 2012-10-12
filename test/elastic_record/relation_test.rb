require 'helper'

class ElasticRecord::RelationTest < MiniTest::Spec
  def setup
    super
    Widget.elastic_index.reset
  end

  def test_count
    create_widgets [Widget.new(id: 5, color: 'red'), Widget.new(id: 10, color: 'blue')]

    assert_equal 2, Widget.elastic_relation.count
  end

  def test_facets
    create_widgets [Widget.new(id: 5, color: 'red'), Widget.new(id: 10, color: 'blue')]

    facets = Widget.elastic_relation.facet(Widget.arelastic.facet['popular_colors'].terms('color')).facets

    assert_equal 2, facets['popular_colors']['total']
  end

  def test_create_percolator
    Widget.elastic_relation.filter(color: 'green').create_percolator('green')
    Widget.elastic_relation.filter(color: 'blue').create_percolator('blue')
    widget = Widget.new(color: 'green')

    assert_equal ['green'], Widget.elastic_index.percolate(widget.as_search)
  end

  def test_explain
    create_widgets [Widget.new(id: 10, color: 'blue')]

    # explain = Widget.elastic_relation.filter(color: 'blue').explain('10')
    # p "explain = #{explain}"
  end

  def test_to_hits
    # assert Widget.elastic_relation.search_results.is_a?(ElasticSearch::Api::Hits)
  end

  def test_to_ids
    create_widgets [Widget.new(id: 5, color: 'red'), Widget.new(id: 10, color: 'blue')]

    assert_equal ['5', '10'], Widget.elastic_relation.to_ids
  end

  def test_to_a
    create_widgets [Widget.new(id: 5, color: 'red'), Widget.new(id: 10, color: 'blue')]
    
    array = Widget.elastic_relation.to_a

    assert_equal 2, array.size
    assert array.first.is_a?(Widget)
  end

  def test_equal
    create_widgets [Widget.new(id: 5, color: 'red'), Widget.new(id: 10, color: 'blue')]

    assert(Widget.elastic_relation.filter(color: 'green') == Widget.elastic_relation.filter(color: 'green'))
    assert(Widget.elastic_relation.filter(color: 'green') != Widget.elastic_relation.filter(color: 'blue'))

    assert(Widget.elastic_relation.filter(color: 'magenta') == [])
  end

  def test_inspect
    assert_equal [].inspect, Widget.elastic_relation.filter(color: 'magenta').inspect
  end

  private
    def create_widgets(widgets)
      Widget.elastic_index.bulk_add(widgets)
      Widget.elastic_index.refresh
    end
end