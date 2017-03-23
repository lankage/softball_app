module ApplicationHelper
  
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = "Wisco Kids App"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def human_boolean(boolean)
    boolean ? 'Yes' : 'No'
    if boolean == 1
    	boolean = 'Yes'
    else
    	boolean = 'No'
    end
  end


end
