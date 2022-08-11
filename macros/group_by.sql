{% macro group_by(sources) %}
    {% set ns = namespace(hasAgg = false) %}
    {% set nsgb = namespace(groupBy = 'GROUP BY ') %}
    {% set nsa = namespace(aggregateFunctions = ['ANY_VALUE','AVG','CORR','COUNT','COUNT_IF','COVAR_POP','COVAR_SAMP','LISTAGG','MAX','MEDIAN','MIN','MODE','PERCENTILE_CONT','PERCENTILE_DISC','STDDEV','STDDEV_POP','STDDEV_SAMP','SUM','VAR_POP','VAR_SAMP','VARIANCE_POP','VARIANCE','VARIANCE_SAMP']) %}
    {% for source in sources %}
        {% if ns.hasAgg == false %}
            {% for col in source.columns %}
                    {% set transform = get_source_transform(col) %}
                    {% set transform = transform[:transform.find('(')] %}
                        {% if transform|trim in nsa.aggregateFunctions %}
                            {% set ns.hasAgg = true %}
                        {% endif %}
            {% endfor %}
        {% endif %}
    {% endfor %}
    {% if ns.hasAgg == true %}
        {% for source in sources %}
            {% for col in source.columns %}
                {% set transform = get_source_transform(col) %}
                {% set transform = transform[:transform.find('(')] | trim %}
                    {% if  not transform in nsa.aggregateFunctions %}
                        {%- if not loop.last -%}
                            {% set nsgb.groupBy = nsgb.groupBy ~ '"' ~ col.name ~ '"' ~ ',' %}
                        {% else %}
                            {% set nsgb.groupBy = nsgb.groupBy ~ '"' ~ col.name ~ '"' %}
                        {% endif %}
                    {% endif %}
            {% endfor %}
        {% endfor %}
    {{ nsgb.groupBy }}
    {% endif %}
{% endmacro %}